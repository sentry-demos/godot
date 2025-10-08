#!/bin/bash
# Requires: SCons, Python, Xcode, sentry-cli.
# Run on macOS.

starting_dir=$(pwd)

cd "$(dirname "$0")/.."

echo "Removing old builds..."

pushd addons/gamelogic/bin
rm libgamelogic.macos.debug.universal.dylib
rm libgamelogic.macos.release.universal.dylib
rm -R libgamelogic.macos.debug.universal.dylib.dSYM
rm -R libgamelogic.macos.release.universal.dylib.dSYM
popd

echo "Building..."

scons platform=macos target=template_release debug_symbols=yes
scons platform=macos target=editor debug_symbols=yes

echo "Done building."

cd addons/gamelogic/bin

echo "Separating debug symbols..."

dsymutil libgamelogic.macos.debug.universal.dylib
dsymutil libgamelogic.macos.release.universal.dylib

strip -x libgamelogic.macos.debug.universal.dylib
strip -x libgamelogic.macos.release.universal.dylib

echo "Creating source bundles..."

sentry-cli debug-files bundle-sources libgamelogic.macos.debug.universal.dylib.dSYM
sentry-cli debug-files bundle-sources libgamelogic.macos.release.universal.dylib.dSYM

echo "Done!"

cd ${starting_dir}
