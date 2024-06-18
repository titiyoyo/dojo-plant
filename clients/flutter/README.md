# test_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Extra install steps on iphone
```
export FLUTTER_PATH="~/.flutter"
# Dart
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/dart-sdk/bin/dart"
# idevice_id
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/artifacts/libimobiledevice/idevice_id"
# ideviceinfo
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/artifacts/libimobiledevice/ideviceinfo"
# idevicename
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/artifacts/libimobiledevice/idevicename"
# idevicescreenshot
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/artifacts/libimobiledevice/idevicescreenshot"
# idevicesyslog
sudo xattr -d com.apple.quarantine "$FLUTTER_PATH/bin/cache/artifacts/libimobiledevice/idevicesyslog"
```