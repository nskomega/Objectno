# iOS build and signing

Xcode 27.2 is installed and selected; minimum deployment target is iOS 15.
Apple Development and Apple Distribution identities are available in the local keychain. The development certificate subject confirms team FKJRTB74YX. No private key was exported. A later check found the connected iPhone 6s on iOS 15.8.8 in Finder and ideviceinfo. Xcode 27.2 physical-device development requires iOS 17+, even though its deployment targets include iOS 15. Source: https://developer.apple.com/xcode/system-requirements . Account presence alone does not prove App Store Connect access.

## Simulator on this Mac
Run `scripts/build-ios-simulator.sh` with Flutter on PATH. It generates Flutter configuration, then builds one host architecture using xcodebuild. Artifact: build/ios/Debug-iphonesimulator/Runner.app.

Flutter 3.44.2 tries `lipo -verify_arch arm64 x86_64` and Xcode 27 rejects the multi-architecture check. Building one architecture avoids the failure without changing the shared Flutter SDK. Upstream: https://github.com/flutter/flutter/issues/188461 .

The script strips the development suffix from VERSION for the platform build name and takes the numeric build number from pubspec.yaml. For example dev.12 becomes build name 0.1.0 and build number 12. Do not pass the development suffix directly to store tooling: an earlier default iOS build produced a four-component short version (0.1.0.8), which is not our intended release name.

## Remaining gates
Development team selection and provisioning for a real device; launch and camera/secure storage checks on hardware; signed archive and valid store version/build numbers; App Store Connect record, privacy/support metadata and the full renovation workflow. A simulator app is not a signed store archive. No upload or publication has occurred.

## Installed on iPhone 6s (dev.15 record)
Build a release app with explicit store-compatible numbers, for example:

```sh
flutter build ios --release --no-codesign --build-name=0.1.0 --build-number=14
python3 scripts/sign-ios-development.py build/ios/iphoneos/Runner.app
ideviceinstaller install build/ios/iphoneos/Runner.app
ideviceinstaller list -b dev.objectno.objectno
```

Requires libimobiledevice and ideviceinstaller from Homebrew. The helper only uses an existing unexpired wildcard development profile containing the connected phone and a certificate whose private key is already available locally. It signs embedded frameworks and the app, embeds the profile, expands app/keychain identifiers and verifies the signatures. It does not register devices, request new profiles or export private keys. Profiles and signed artifacts remain under ignored build/ and outside Git. Pin iOS 15 explicitly after Xcode's automatic project migration.

Verified build 14 installation completed on the connected phone with the new icon. Launch confirmation and functional hardware testing remain pending. This is development signing, not App Store distribution.

## Hardware launch confirmation
The owner confirmed that the installed build 14 opens the home screen on iPhone 6s / iOS 15.8.8. Recorded in dev.16. Camera, persistence and secure-storage checks remain separate, pending checks. No App Store publication is implied.

## Camera and data persistence
The owner completed the physical-device scenario on installed build 14: create property, add issue, capture and save a photo, force-close the app and reopen the same issue. The saved photo remained visible. Recorded in dev.17. Denied permissions, interrupted capture and secure storage are separate unverified scenarios.

## Unified-history update installed
On 2026-11-01 build 20 was signed and installed after the owner reconnected the iPhone. Installation completed and the device app query returned build 20. No uninstall was performed. Legacy-photo retention and new-history behavior are pending manual checks; do not infer those from install success. Recorded in documentation version dev.21.

## Build 20 manual checks confirmed
The owner confirmed legacy issue/photo retention in the updated history and successful creation of a new object with wishes and its initial photo in a Before entry. Recorded 2026-11-01 in dev.22. Progress/result events, measurements and inference remain separate checks/features.

## Keychain на симуляторе
С dev.29 scripts/build-ios-simulator.sh включает штатную ad-hoc подпись Xcode, которая также создаёт simulated entitlements. CODE_SIGNING_ALLOWED=NO оставлял приложение без Keychain identity и приводил к -34018. Нельзя подменять нативное безопасное хранилище памятью для сокрытия этой ошибки. Это отдельный путь от подписи настоящего устройства. Документация Apple: https://developer.apple.com/forums/thread/114456 .
