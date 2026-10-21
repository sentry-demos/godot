#!/bin/bash
# Requires: Git, SCons, Python, Xcode, sentry-cli.
# Run on macOS.

set -euo pipefail

main() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
    git submodule update --init --recursive -- addons/gamelogic/src/godot-cpp

    rm -f addons/gamelogic/bin/libgamelogic.macos.{debug,release}.universal.dylib
    rm -f addons/gamelogic/bin/libgamelogic.macos.{debug,release}.universal.dylib*.src.zip
    rm -rf addons/gamelogic/bin/libgamelogic.macos.{debug,release}.universal.dylib.dSYM

    echo "Building..."
    scons platform=macos arch=universal api_version=4.5 target=template_release debug_symbols=yes
    scons platform=macos arch=universal api_version=4.5 target=editor debug_symbols=yes

    cd addons/gamelogic/bin
    local target binary
    for target in debug release; do
        binary="libgamelogic.macos.${target}.universal.dylib"
        echo "Separating debug symbols for $binary..."
        dsymutil "$binary"
        strip -x "$binary"

        echo "Creating source bundles for $binary..."
        sentry-cli debug-files bundle-sources "$binary.dSYM"
        test -s "$binary.src.zip"
    done
}

main "$@"
