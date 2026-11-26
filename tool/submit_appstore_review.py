#!/usr/bin/env python3
"""
EthioChef - App Store Review Automated Submitter
Submits an uploaded iOS build to Apple App Store Review via App Store Connect REST API.

Can be run in GitHub Actions (ubuntu-latest) or locally.
Requires environment variables:
  - APPSTORE_KEY_ID
  - APPSTORE_ISSUER_ID
  - APPSTORE_API_KEY_BASE64
"""

import argparse
import base64
import os
import re
import sys
import time
import requests
import jwt

API_BASE = "https://api.appstoreconnect.apple.com/v1"


def print_step(msg: str):
    print(f"--> {msg}", flush=True)


def print_success(msg: str):
    print(f"[✓] {msg}", flush=True)


def print_error(msg: str):
    print(f"[X] {msg}", flush=True)


def get_token(key_id: str, issuer_id: str, private_key_pem: str) -> str:
    headers = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    payload = {
        "iss": issuer_id,
        "exp": int(time.time()) + 1200,  # 20 minutes
        "aud": "appstoreconnect-v1",
    }
    return jwt.encode(payload, private_key_pem, algorithm="ES256", headers=headers)


def read_pubspec_version() -> tuple[str, str]:
    with open("pubspec.yaml", "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("version:"):
                raw = line.split(":", 1)[1].strip()
                match = re.match(r"^(\d+\.\d+\.\d+)(?:\+(\d+))?$", raw)
                if match:
                    return match.group(1), match.group(2) or "1"
    raise ValueError("Could not find version in pubspec.yaml")


class AppStoreClient:
    def __init__(self, key_id: str, issuer_id: str, private_key_pem: str):
        self.key_id = key_id
        self.issuer_id = issuer_id
        self.private_key_pem = private_key_pem
        self._token_generated_at = 0
        self._cached_token = ""

    @property
    def token(self) -> str:
        # Refresh token every 15 minutes
        if time.time() - self._token_generated_at > 900:
            self._cached_token = get_token(self.key_id, self.issuer_id, self.private_key_pem)
            self._token_generated_at = time.time()
        return self._cached_token

    def request(self, method: str, path: str, json_data=None, params=None) -> requests.Response:
        url = path if path.startswith("http") else f"{API_BASE}{path}"
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
        res = requests.request(method, url, headers=headers, json=json_data, params=params)
        return res

    def get_app_id(self, bundle_id: str) -> str:
        print_step(f"Looking up App ID for bundle '{bundle_id}'...")
        res = self.request("GET", "/apps", params={"filter[bundleId]": bundle_id})
        if res.status_code != 200:
            raise RuntimeError(f"Failed to fetch apps: {res.status_code} {res.text}")
        data = res.json().get("data", [])
        if not data:
            raise RuntimeError(f"App with bundle ID '{bundle_id}' not found in App Store Connect")
        app_id = data[0]["id"]
        app_name = data[0]["attributes"].get("name", "Unknown")
        print_success(f"Found app '{app_name}' (ID: {app_id})")
        return app_id

    def wait_for_build(self, app_id: str, build_number: str, max_wait_mins: int = 30) -> str:
        print_step(f"Waiting for build {build_number} to finish processing on Apple servers (timeout: {max_wait_mins}m)...")
        start_time = time.time()
        attempts = 0

        while (time.time() - start_time) < (max_wait_mins * 60):
            attempts += 1
            res = self.request(
                "GET",
                "/builds",
                params={
                    "filter[app]": app_id,
                    "filter[version]": build_number,
                    "sort": "-uploadedDate",
                    "limit": 1,
                },
            )
            if res.status_code == 200:
                builds = res.json().get("data", [])
                if builds:
                    build = builds[0]
                    state = build["attributes"].get("processingState")
                    elapsed = int((time.time() - start_time) / 60)
                    print(f"  [Attempt {attempts} | {elapsed}m] Build {build_number} state: {state}", flush=True)

                    if state == "VALID":
                        build_id = build["id"]
                        print_success(f"Build {build_number} is processed and VALID (ID: {build_id})")
                        self._ensure_export_compliance(build_id, build)
                        return build_id
                    elif state in ["FAILED", "INVALID"]:
                        raise RuntimeError(f"Build processing failed on Apple's servers with state: {state}")
                else:
                    print(f"  [Attempt {attempts}] Build {build_number} not listed yet in App Store Connect...", flush=True)
            else:
                print(f"  [Attempt {attempts}] Warning: API returned {res.status_code} {res.text[:100]}", flush=True)

            time.sleep(30)

        raise TimeoutError(f"Timed out after {max_wait_mins} minutes waiting for build {build_number} to process.")

    def _ensure_export_compliance(self, build_id: str, build_data: dict):
        uses_encryption = build_data.get("attributes", {}).get("usesNonExemptEncryption")
        if uses_encryption is None:
            print_step(f"Setting export compliance (usesNonExemptEncryption: false) on build {build_id}...")
            payload = {
                "data": {
                    "type": "builds",
                    "id": build_id,
                    "attributes": {
                        "usesNonExemptEncryption": False,
                    },
                }
            }
            res = self.request("PATCH", f"/builds/{build_id}", json_data=payload)
            if res.status_code in [200, 204]:
                print_success("Export compliance set successfully")
            else:
                print(f"  (Compliance patch notice: {res.status_code} {res.text[:120]})", flush=True)

    def get_or_create_app_store_version(self, app_id: str, version_name: str) -> str:
        print_step(f"Checking for editable App Store version '{version_name}'...")
        res = self.request(
            "GET",
            f"/apps/{app_id}/appStoreVersions",
            params={
                "filter[platform]": "IOS",
                "filter[appStoreState]": "PREPARE_FOR_SUBMISSION,DEVELOPER_REJECTED,REJECTED",
            },
        )
        if res.status_code != 200:
            raise RuntimeError(f"Failed to query appStoreVersions: {res.status_code} {res.text}")

        versions = res.json().get("data", [])
        if versions:
            ver = versions[0]
            ver_id = ver["id"]
            current_ver_str = ver["attributes"].get("versionString")
            print_success(f"Found editable version '{current_ver_str}' (ID: {ver_id})")

            if current_ver_str != version_name:
                print_step(f"Updating version string from '{current_ver_str}' to '{version_name}'...")
                patch_payload = {
                    "data": {
                        "type": "appStoreVersions",
                        "id": ver_id,
                        "attributes": {"versionString": version_name},
                    }
                }
                patch_res = self.request("PATCH", f"/appStoreVersions/{ver_id}", json_data=patch_payload)
                if patch_res.status_code == 200:
                    print_success(f"Version string updated to '{version_name}'")
                else:
                    print(f"  (Version string update notice: {patch_res.status_code} {patch_res.text[:100]})")
            return ver_id

        # No editable version found, create new one
        print_step(f"No editable version found. Creating App Store version '{version_name}'...")
        create_payload = {
            "data": {
                "type": "appStoreVersions",
                "attributes": {
                    "platform": "IOS",
                    "versionString": version_name,
                },
                "relationships": {
                    "app": {
                        "data": {"type": "apps", "id": app_id}
                    }
                },
            }
        }
        create_res = self.request("POST", "/appStoreVersions", json_data=create_payload)
        if create_res.status_code in [200, 201]:
            new_id = create_res.json()["data"]["id"]
            print_success(f"Created new App Store version '{version_name}' (ID: {new_id})")
            return new_id
        else:
            raise RuntimeError(f"Failed to create app store version: {create_res.status_code} {create_res.text}")

    def update_release_notes(self, version_id: str, notes: str):
        if not notes:
            return
        print_step("Updating release notes ('What's New in This Version')...")
        res = self.request("GET", f"/appStoreVersions/{version_id}/appStoreVersionLocalizations")
        if res.status_code != 200:
            print(f"  Notice: Could not fetch localizations: {res.status_code}")
            return
        locs = res.json().get("data", [])
        for loc in locs:
            loc_id = loc["id"]
            locale = loc["attributes"].get("locale", "default")
            patch_data = {
                "data": {
                    "type": "appStoreVersionLocalizations",
                    "id": loc_id,
                    "attributes": {
                        "whatsNew": notes,
                    },
                }
            }
            patch_res = self.request("PATCH", f"/appStoreVersionLocalizations/{loc_id}", json_data=patch_data)
            if patch_res.status_code in [200, 204]:
                print_success(f"Updated release notes for locale '{locale}'")
            else:
                print(f"  Notice for locale '{locale}': {patch_res.status_code} {patch_res.text[:100]}")

    def attach_build_to_version(self, version_id: str, build_id: str):
        print_step(f"Attaching build {build_id} to App Store version {version_id}...")
        payload = {
            "data": {
                "type": "builds",
                "id": build_id,
            }
        }
        res = self.request("PATCH", f"/appStoreVersions/{version_id}/relationships/build", json_data=payload)
        if res.status_code in [200, 204]:
            print_success("Build successfully attached to version!")
        else:
            raise RuntimeError(f"Failed to attach build to version: {res.status_code} {res.text}")

    def submit_for_review(self, app_id: str, version_id: str):
        print_step("Submitting app version to App Store Review...")

        # 1. Check if an active review submission already exists
        check_res = self.request(
            "GET",
            f"/apps/{app_id}/reviewSubmissions",
            params={
                "filter[platform]": "IOS",
                "filter[state]": "READY_FOR_REVIEW",
            },
        )
        sub_id = None
        if check_res.status_code == 200:
            subs = check_res.json().get("data", [])
            if subs:
                sub_id = subs[0]["id"]
                print(f"  Using existing Review Submission draft (ID: {sub_id})")

        # 2. Create review submission if none exists
        if not sub_id:
            create_payload = {
                "data": {
                    "type": "reviewSubmissions",
                    "attributes": {
                        "platform": "IOS",
                    },
                    "relationships": {
                        "app": {
                            "data": {"type": "apps", "id": app_id}
                        }
                    },
                }
            }
            create_res = self.request("POST", "/reviewSubmissions", json_data=create_payload)
            if create_res.status_code in [200, 201]:
                sub_id = create_res.json()["data"]["id"]
                print_success(f"Created new Review Submission (ID: {sub_id})")
            else:
                print_error(f"Could not create review submission: {create_res.status_code} {create_res.text}")
                self._submit_legacy(version_id)
                return

        # 3. Add appStoreVersion item to review submission
        item_payload = {
            "data": {
                "type": "reviewSubmissionItems",
                "relationships": {
                    "reviewSubmission": {
                        "data": {"type": "reviewSubmissions", "id": sub_id}
                    },
                    "appStoreVersion": {
                        "data": {"type": "appStoreVersions", "id": version_id}
                    },
                },
            }
        }
        item_res = self.request("POST", "/reviewSubmissionItems", json_data=item_payload)
        if item_res.status_code in [200, 201]:
            print_success("Added version item to review submission")
        elif item_res.status_code == 409:
            print("  Item already present in review submission")
        else:
            print(f"  Notice adding submission item: {item_res.status_code} {item_res.text[:120]}")

        # 4. Finalize submission (set submitted: true)
        submit_payload = {
            "data": {
                "type": "reviewSubmissions",
                "id": sub_id,
                "attributes": {
                    "submitted": True,
                },
            }
        }
        final_res = self.request("PATCH", f"/reviewSubmissions/{sub_id}", json_data=submit_payload)
        if final_res.status_code in [200, 204]:
            print_success("App version successfully submitted to App Store Review!")
        else:
            print_error(f"Failed to submit review submission: {final_res.status_code} {final_res.text}")
            print("You can complete the final 1-click submission in the App Store Connect portal.")

    def _submit_legacy(self, version_id: str):
        print_step("Attempting legacy appStoreVersionSubmissions endpoint...")
        payload = {
            "data": {
                "type": "appStoreVersionSubmissions",
                "relationships": {
                    "appStoreVersion": {
                        "data": {"type": "appStoreVersions", "id": version_id}
                    }
                },
            }
        }
        res = self.request("POST", "/appStoreVersionSubmissions", json_data=payload)
        if res.status_code in [200, 201]:
            print_success("App successfully submitted via appStoreVersionSubmissions!")
        else:
            print_error(f"Legacy submission response: {res.status_code} {res.text}")


def main():
    parser = argparse.ArgumentParser(description="Submit iOS build to App Store Review via App Store Connect API")
    parser.add_argument("--build-number", help="Build number (e.g. 93)")
    parser.add_argument("--version-name", help="Version name (e.g. 4.0.27)")
    parser.add_argument("--notes", default="Bug fixes and optimizations", help="Release notes")
    parser.add_argument("--bundle-id", default="com.peacetechnology.ethiochef", help="Bundle ID")
    parser.add_argument("--max-wait-mins", type=int, default=30, help="Max minutes to wait for processing")
    args = parser.parse_args()

    key_id = os.environ.get("APPSTORE_KEY_ID")
    issuer_id = os.environ.get("APPSTORE_ISSUER_ID")
    key_b64 = os.environ.get("APPSTORE_API_KEY_BASE64")

    if not key_id or not issuer_id or not key_b64:
        print_error("Missing required environment variables: APPSTORE_KEY_ID, APPSTORE_ISSUER_ID, APPSTORE_API_KEY_BASE64")
        sys.exit(1)

    try:
        private_key_pem = base64.b64decode(key_b64).decode("utf-8")
    except Exception as e:
        print_error(f"Failed to decode APPSTORE_API_KEY_BASE64: {e}")
        sys.exit(1)

    # Resolve version info and notes
    version_name = args.version_name or os.environ.get("INPUT_VERSION_NAME")
    build_number = args.build_number or os.environ.get("INPUT_BUILD_NUMBER")
    notes = os.environ.get("INPUT_RELEASE_NOTES") or args.notes or "Bug fixes and optimizations"
    if not version_name or not build_number:
        try:
            detected_ver, detected_build = read_pubspec_version()
            version_name = version_name or detected_ver
            build_number = build_number or detected_build
        except Exception as e:
            print_error(f"Could not read version from pubspec.yaml: {e}")
            sys.exit(1)

    print("======================================================================")
    print("  EthioChef — App Store Review Submitter")
    print("======================================================================")
    print(f"Bundle ID:     {args.bundle_id}")
    print(f"Version Name:  {version_name}")
    print(f"Build Number:  {build_number}")
    print(f"Release Notes: {notes}")
    print("======================================================================\n")

    client = AppStoreClient(key_id, issuer_id, private_key_pem)

    try:
        app_id = client.get_app_id(args.bundle_id)
        build_id = client.wait_for_build(app_id, build_number, max_wait_mins=args.max_wait_mins)
        version_id = client.get_or_create_app_store_version(app_id, version_name)
        client.update_release_notes(version_id, notes)
        client.attach_build_to_version(version_id, build_id)
        client.submit_for_review(app_id, version_id)
        print("\n======================================================================")
        print("  Process Completed Successfully!")
        print("======================================================================")
    except Exception as e:
        print_error(f"Review submission process encountered an error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
