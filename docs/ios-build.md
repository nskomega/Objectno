# iOS build and signing

Xcode 27.2 is installed and selected; minimum deployment target is iOS 15.
Apple Development and Apple Distribution identities are available in the local keychain. The development certificate subject confirms team FKJRTB74YX. No private key was exported. A physical iPhone was not listed during the check; account presence alone does not prove a usable provisioning profile or App Store Connect access.

## Simulator on this Mac
Run `scripts/build-ios-simulator.sh` with Flutter on PATH. It generates Flutter configuration, then builds one host architecture using xcodebuild. Artifact: build/ios/Debug-iphonesimulator/Runner.app.

Flutter 3.44.2 tries `lipo -verify_arch arm64 x86_64` and Xcode 27 rejects the multi-architecture check. Building one architecture avoids the failure without changing the shared Flutter SDK. Upstream: https://github.com/flutter/flutter/issues/188461 .

The script strips the development suffix from VERSION for the platform build name and takes the numeric build number from pubspec.yaml. For example dev.12 becomes build name 0.1.0 and build number 12. Do not pass the development suffix directly to store tooling: an earlier default iOS build produced a four-component short version (0.1.0.8), which is not our intended release name.

## Remaining gates
Development team selection and provisioning for a real device; launch and camera/secure storage checks on hardware; signed archive and valid store version/build numbers; App Store Connect record, privacy/support metadata and the full renovation workflow. A simulator app is not a signed store archive. No upload or publication has occurred.
