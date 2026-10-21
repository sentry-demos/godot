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

    local target build_target binary
    for target in release debug; do
        build_target=template_release
        if [[ "$target" == debug ]]; then
            build_target=editor
        fi

        echo "Building $target..."
        scons platform=macos arch=universal api_version=4.5 target="$build_target" debug_symbols=yes --clean
        scons platform=macos arch=universal api_version=4.5 target="$build_target" debug_symbols=yes

        # dsymutil needs the object files before the next target overwrites them.
        binary="addons/gamelogic/bin/libgamelogic.macos.${target}.universal.dylib"
        echo "Separating debug symbols for $binary..."
        dsymutil "$binary"
        strip -x "$binary"

        echo "Creating source bundles for $binary..."
        sentry-cli debug-files bundle-sources "$binary.dSYM"
        test -s "$binary.src.zip"
    done
}

main "$@"
