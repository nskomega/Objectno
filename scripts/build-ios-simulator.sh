#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
# Keep SemVer prerelease metadata out of CFBundleShortVersionString.
release_name=$(sed -n 's/^\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*$/\1/p' VERSION)
build_number=$(sed -n 's/^version: .*+\([0-9][0-9]*\)$/\1/p' pubspec.yaml)
[ -n "$release_name" ] && [ -n "$build_number" ]
case "$(uname -m)" in
  arm64) simulator_arch=arm64 ;;
  x86_64) simulator_arch=x86_64 ;;
  *) echo 'Unsupported simulator host architecture' >&2; exit 1 ;;
esac
flutter build ios --simulator --debug --config-only \
  --build-name="$release_name" --build-number="$build_number" "$@"
# Single architecture also avoids the multi-arch lipo verification bug in
# Flutter 3.44.2 with Xcode 27. No global Flutter SDK changes are required.
xcrun xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner \
  -configuration Debug -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  ARCHS="$simulator_arch" ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=NO \
  BUILD_DIR="$PWD/build/ios" build
