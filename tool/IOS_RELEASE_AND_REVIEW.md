# EthioChef — iOS Cloud Release & App Store Review Automation

Complete guide to building, releasing to TestFlight, and submitting **EthioChef** (`com.peacetechnology.ethiochef`) to Apple App Store Review from Windows without local macOS hardware, using the shared Apple Developer team (`T6N9PJTZS6`).

---

## Architecture Overview

```
                                      [Windows Dev Machine]
                                                │
                          dart run tool/release_ios.dart [--bump=...]
                                                │
                                                ▼
                                     [GitHub origin/<branch>]
                                                │
                                                ▼
                         ┌──────────────────────────────────────────────┐
                         │ .github/workflows/ios_release.yml (macOS)    │
                         │ 1. Checkout repository & setup Flutter/Java  │
                         │ 2. Install distribution cert & profile       │
                         │ 3. Build release IPA via flutter build ipa   │
                         │ 4. Upload IPA to TestFlight via xcrun altool │
                         └──────────────────────────────────────────────┘

                         ┌──────────────────────────────────────────────┐
                         │ .github/workflows/ios_submit_review.yml      │
                         │ (Triggered manually on ubuntu-latest)        │
                         │ 1. Generate App Store Connect JWT token      │
                         │ 2. Poll Apple API until build is VALID       │
                         │ 3. Auto-set export compliance (exempt)       │
                         │ 4. Find or create App Store version          │
                         │ 5. Update "What's New" release notes         │
                         │ 6. Attach build to App Store version         │
                         │ 7. Submit to Apple App Review via API        │
                         └──────────────────────────────────────────────┘
```

---

## 1. Fast Command Reference

All commands run from the root of `ethiochef`:

### A. Deploy New iOS Build to TestFlight
```powershell
# Bump patch (e.g. 4.0.26+92 -> 4.0.27+93), push to git, and trigger cloud release
dart run tool/release_ios.dart --bump=patch

# Bump build number only (e.g. 4.0.26+92 -> 4.0.26+93)
dart run tool/release_ios.dart --bump=build

# Release current version without bumping
dart run tool/release_ios.dart --bump=none

# Compile & export IPA without uploading to TestFlight
dart run tool/release_ios.dart --bump=none --no-upload

# Preview actions without triggering CI
dart run tool/release_ios.dart --dry-run
```

### B. Manually Trigger the App Store Review Submitter
Once a build has uploaded to TestFlight (or is processing/ready in App Store Connect):
```powershell
# Auto-detects version & build from pubspec.yaml
gh workflow run ios_submit_review.yml

# Or specify custom build number, version, and release notes:
gh workflow run ios_submit_review.yml -f build_number=93 -f version_name=4.0.27 -f release_notes="Bug fixes and optimizations"
```

### C. Monitor Progress
```powershell
gh run watch
gh run list --workflow=ios_release.yml
gh run list --workflow=ios_submit_review.yml
```

---

## 2. Workflows & Scripts Breakdown

| File | Environment | Role | Trigger |
|:---|:---|:---|:---|
| [`.github/workflows/ios_release.yml`](file:///c:/flutter_dev/projects/ethiochef/.github/workflows/ios_release.yml) | `xcode-27` (macOS) | Archives Flutter IPA, signs with manual distribution profile, and optionally uploads to App Store Connect via `xcrun altool`. | `workflow_dispatch` |
| [`.github/workflows/ios_submit_review.yml`](file:///c:/flutter_dev/projects/ethiochef/.github/workflows/ios_submit_review.yml) | `ubuntu-latest` | Runs independent review submitter script via App Store Connect REST API. | `workflow_dispatch` |
| [`tool/submit_appstore_review.py`](file:///c:/flutter_dev/projects/ethiochef/tool/submit_appstore_review.py) | Python 3 | Pure REST client for App Store Connect API (`com.peacetechnology.ethiochef`). | Invoked by CI or locally |
| [`tool/release_ios.dart`](file:///c:/flutter_dev/projects/ethiochef/tool/release_ios.dart) | Dart CLI | Local Windows CLI tool to bump versions, commit, push, and dispatch `ios_release.yml`. | `dart run tool/release_ios.dart` |

---

## 3. Required GitHub Secrets

Configure these 7 secrets in `https://github.com/DaV212001/ethiochef/settings/secrets/actions`:

| Secret Name | Source (Same Account `T6N9PJTZS6` as `delivery_app`) |
|:---|:---|
| `APPSTORE_KEY_ID` | **Reuse** the same 10-char Key ID from `delivery_app`. |
| `APPSTORE_ISSUER_ID` | **Reuse** the same Issuer ID UUID from `delivery_app`. |
| `APPSTORE_API_KEY_BASE64` | **Reuse** the same base64-encoded `.p8` key from `delivery_app`. |
| `BUILD_CERTIFICATE_BASE64` | **Reuse** the same base64-encoded Apple Distribution `.p12` from `delivery_app`. |
| `P12_PASSWORD` | **Reuse** the same `.p12` password from `delivery_app`. |
| `KEYCHAIN_PASSWORD` | **Reuse** or set any temporary keychain password string. |
| `BUILD_PROVISION_PROFILE_BASE64` | **New** base64-encoded App Store distribution `.mobileprovision` for `com.peacetechnology.ethiochef`. |

---

## 4. Export Compliance

`ITSAppUsesNonExemptEncryption` is set to `false` in [`ios/Runner/Info.plist`](file:///c:/flutter_dev/projects/ethiochef/ios/Runner/Info.plist), and [`tool/submit_appstore_review.py`](file:///c:/flutter_dev/projects/ethiochef/tool/submit_appstore_review.py) also patches `usesNonExemptEncryption: false` if needed.
