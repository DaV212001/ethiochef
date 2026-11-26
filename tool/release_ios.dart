// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

/// EthioChef — iOS TestFlight Cloud Release Automation Tool
///
/// This script runs on your Windows machine to:
/// 1. Optionally increment the build number / version in pubspec.yaml.
/// 2. Commit and push changes to GitHub.
/// 3. Trigger the GitHub Actions macOS cloud builder (`ios_release.yml`).
/// 4. Stream live progress until the build is uploaded to TestFlight.
///
/// Run:
///   dart run tool/release_ios.dart [options]
///
/// Examples:
///   dart run tool/release_ios.dart                  # Release current version
///   dart run tool/release_ios.dart --bump=build     # Increments build number (+1)
///   dart run tool/release_ios.dart --bump=patch     # Increments patch (4.0.26 -> 4.0.27)
///   dart run tool/release_ios.dart --dry-run
void main(List<String> args) async {
  final config = IOSReleaseConfig.parse(args);

  if (config.showHelp) {
    IOSReleaseConfig.printHelp();
    return;
  }

  final branch = await getCurrentGitBranch();

  printHeader('EthioChef — iOS TestFlight Cloud Release');
  print('Configuration:');
  print('  Git Branch:    $branch');
  print('  Bump Type:     ${config.bumpType}');
  print('  Runner:        ${config.runner}');
  print('  Target Xcode:  ${config.xcodeVersion}');
  print('  Upload to TF:  ${config.upload ? "YES" : "NO"}');
  print('  Dry Run:       ${config.dryRun ? "YES (No changes will be triggered)" : "NO"}');
  print('  Watch Logs:    ${config.watch ? "YES" : "NO"}');
  print('');

  final projectDir = Directory.current;
  final pubspecFile = File('${projectDir.path}/pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    printError('pubspec.yaml not found in ${projectDir.path}');
    exit(1);
  }

  // 1. Version Bumping
  final currentVersionStr = readPubspecVersion(pubspecFile);
  final parsedVersion = VersionInfo.parse(currentVersionStr);
  final newVersion = parsedVersion.bump(config.bumpType, config.customVersion);

  print('Current Version: ${parsedVersion.raw}');
  if (config.bumpType == BumpType.none && config.customVersion == null) {
    print('Keeping existing version: ${parsedVersion.raw}');
  } else {
    printSuccess('New Version:     ${newVersion.raw}');
  }

  if (!config.dryRun && (config.bumpType != BumpType.none || config.customVersion != null)) {
    updatePubspecVersion(pubspecFile, newVersion.raw);
    printSuccess('Updated pubspec.yaml with version: ${newVersion.raw}');

    // Commit and push
    printStep('Committing and pushing updated version to GitHub...');
    await runGitCommand(['add', 'pubspec.yaml']);
    await runGitCommand(['commit', '-m', 'chore(release): bump iOS version to ${newVersion.raw}']);
    await runGitCommand(['push', 'origin', branch]);
    printSuccess('Pushed commit to origin/$branch');
  }

  // 2. Trigger GitHub Actions Cloud Runner
  if (config.dryRun) {
    printStep('[DRY RUN] Would execute: gh workflow run ios_release.yml --ref $branch');
    printSuccess('Dry run finished successfully. No cloud builds triggered.');
    return;
  }

  printStep('Triggering GitHub Actions macOS runner for TestFlight release...');
  final ghArgs = [
    'workflow',
    'run',
    'ios_release.yml',
    '--ref',
    branch,
    '-f',
    'build_number=${newVersion.buildNumber}',
    '-f',
    'version_name=${newVersion.versionName}',
    '-f',
    'runner=${config.runner}',
    '-f',
    'upload_to_testflight=${config.upload ? "true" : "false"}',
    '-f',
    'xcode_version=${config.xcodeVersion}',
  ];

  final triggerProc = await Process.run('gh', ghArgs, workingDirectory: projectDir.path);
  if (triggerProc.exitCode != 0) {
    printError('Failed to trigger workflow: ${triggerProc.stderr}');
    exit(1);
  }
  printSuccess('Workflow successfully triggered on GitHub Actions!');

  if (config.watch) {
    printStep('Waiting for runner to start and streaming live progress...');
    await Future.delayed(const Duration(seconds: 4));

    // Watch latest run
    final watchProc = await Process.start('gh', ['run', 'watch'], workingDirectory: projectDir.path, mode: ProcessStartMode.inheritStdio);
    await watchProc.exitCode;
    printHeader('Cloud Build & TestFlight Upload Finished!');
  } else {
    print('');
    printSuccess('Build is running in the cloud! Check status anytime with:');
    print('  gh run watch');
  }
}

enum BumpType { build, patch, minor, major, none }

class VersionInfo {
  final int major;
  final int minor;
  final int patch;
  final int buildNumber;
  final String raw;

  VersionInfo({
    required this.major,
    required this.minor,
    required this.patch,
    required this.buildNumber,
    required this.raw,
  });

  String get versionName => '$major.$minor.$patch';

  static VersionInfo parse(String raw) {
    final regex = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:\+(\d+))?$');
    final match = regex.firstMatch(raw.trim());
    if (match == null) {
      throw FormatException('Cannot parse version format: "$raw"');
    }
    return VersionInfo(
      major: int.parse(match.group(1)!),
      minor: int.parse(match.group(2)!),
      patch: int.parse(match.group(3)!),
      buildNumber: match.group(4) != null ? int.parse(match.group(4)!) : 1,
      raw: raw.trim(),
    );
  }

  VersionInfo bump(BumpType type, String? custom) {
    if (custom != null && custom.isNotEmpty) {
      return VersionInfo.parse(custom);
    }
    switch (type) {
      case BumpType.build:
        final nextBuild = buildNumber + 1;
        return VersionInfo(
          major: major,
          minor: minor,
          patch: patch,
          buildNumber: nextBuild,
          raw: '$major.$minor.$patch+$nextBuild',
        );
      case BumpType.patch:
        final nextPatch = patch + 1;
        final nextBuild = buildNumber + 1;
        return VersionInfo(
          major: major,
          minor: minor,
          patch: nextPatch,
          buildNumber: nextBuild,
          raw: '$major.$minor.$nextPatch+$nextBuild',
        );
      case BumpType.minor:
        final nextMinor = minor + 1;
        final nextBuild = buildNumber + 1;
        return VersionInfo(
          major: major,
          minor: nextMinor,
          patch: 0,
          buildNumber: nextBuild,
          raw: '$major.$nextMinor.0+$nextBuild',
        );
      case BumpType.major:
        final nextMajor = major + 1;
        final nextBuild = buildNumber + 1;
        return VersionInfo(
          major: nextMajor,
          minor: 0,
          patch: 0,
          buildNumber: nextBuild,
          raw: '$nextMajor.0.0+$nextBuild',
        );
      case BumpType.none:
        return this;
    }
  }
}

class IOSReleaseConfig {
  final BumpType bumpType;
  final String? customVersion;
  final bool dryRun;
  final bool watch;
  final bool upload;
  final String xcodeVersion;
  final String runner;
  final bool showHelp;

  IOSReleaseConfig({
    required this.bumpType,
    required this.customVersion,
    required this.dryRun,
    required this.watch,
    this.upload = true,
    this.xcodeVersion = 'default',
    this.runner = 'xcode-27',
    required this.showHelp,
  });

  static IOSReleaseConfig parse(List<String> args) {
    BumpType bumpType = BumpType.none;
    String? customVersion;
    bool dryRun = false;
    bool watch = true;
    bool upload = true;
    String xcodeVersion = 'default';
    String runner = 'xcode-27';
    bool showHelp = false;

    for (final arg in args) {
      if (arg == '--help' || arg == '-h') {
        showHelp = true;
      } else if (arg == '--dry-run') {
        dryRun = true;
      } else if (arg == '--no-watch') {
        watch = false;
      } else if (arg == '--no-upload' || arg == '--upload=false') {
        upload = false;
      } else if (arg.startsWith('--xcode=')) {
        xcodeVersion = arg.substring('--xcode='.length);
      } else if (arg.startsWith('--runner=')) {
        runner = arg.substring('--runner='.length);
      } else if (arg.startsWith('--bump=')) {
        final val = arg.substring('--bump='.length).toLowerCase();
        switch (val) {
          case 'build':
            bumpType = BumpType.build;
            break;
          case 'patch':
            bumpType = BumpType.patch;
            break;
          case 'minor':
            bumpType = BumpType.minor;
            break;
          case 'major':
            bumpType = BumpType.major;
            break;
          case 'none':
            bumpType = BumpType.none;
            break;
        }
      } else if (arg.startsWith('--version=')) {
        customVersion = arg.substring('--version='.length);
      }
    }

    return IOSReleaseConfig(
      bumpType: bumpType,
      customVersion: customVersion,
      dryRun: dryRun,
      watch: watch,
      upload: upload,
      xcodeVersion: xcodeVersion,
      runner: runner,
      showHelp: showHelp,
    );
  }

  static void printHelp() {
    print('EthioChef — iOS TestFlight Release Automation');
    print('Usage: dart run tool/release_ios.dart [options]');
    print('');
    print('Options:');
    print('  --bump=<type>       Bumping strategy: build, patch, minor, major, none (default: none)');
    print('  --version=<x.y.z+n> Override version directly');
    print('  --runner=<image>    macOS runner image (default: xcode-27)');
    print('  --xcode=<version>   Target Xcode / iOS SDK version (default: runner default)');
    print('  --no-upload         Compile and package IPA without uploading to TestFlight');
    print('  --dry-run           Preview actions without pushing or triggering CI');
    print('  --no-watch          Trigger workflow and return immediately without streaming logs');
    print('  --help, -h          Show this help message');
  }
}

Future<String> getCurrentGitBranch() async {
  final res = await Process.run('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
  if (res.exitCode != 0) {
    throw Exception('Failed to determine current git branch: ${res.stderr}');
  }
  final branch = res.stdout.toString().trim();
  if (branch.isEmpty || branch == 'HEAD') {
    throw Exception('Detached HEAD state detected; please checkout a branch before releasing.');
  }
  return branch;
}

String readPubspecVersion(File file) {
  final lines = file.readAsLinesSync();
  for (final line in lines) {
    if (line.trim().startsWith('version:')) {
      return line.split(':')[1].trim();
    }
  }
  throw Exception('Version line not found in pubspec.yaml');
}

void updatePubspecVersion(File file, String newVersion) {
  final content = file.readAsStringSync();
  final updated = content.replaceFirst(RegExp(r'version:\s*[^\r\n]+'), 'version: $newVersion');
  file.writeAsStringSync(updated);
}

Future<void> runGitCommand(List<String> args) async {
  final res = await Process.run('git', args);
  if (res.exitCode != 0) {
    throw Exception('git ${args.join(" ")} failed: ${res.stderr}');
  }
}

void printHeader(String text) {
  print('======================================================================');
  print('  $text');
  print('======================================================================');
}

void printStep(String text) => print('--> $text');
void printSuccess(String text) => print('[\u2713] $text');
void printError(String text) => print('[X] $text');
