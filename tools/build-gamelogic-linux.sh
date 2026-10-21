#!/usr/bin/env bash
# Requires: Git, SCons, GCC, GNU Binutils, sentry-cli.
# Run on Linux x86_64.

set -euo pipefail

main() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
    git submodule update --init --recursive -- addons/gamelogic/src/godot-cpp

    rm -f addons/gamelogic/bin/libgamelogic.linux.{debug,release}.x86_64.so{,.debug,.src.zip}

    echo "Building..."
    scons -j"$(nproc)" platform=linux arch=x86_64 api_version=4.5 target=template_release debug_symbols=yes --clean
    scons -j"$(nproc)" platform=linux arch=x86_64 api_version=4.5 target=template_release debug_symbols=yes
    scons -j"$(nproc)" platform=linux arch=x86_64 api_version=4.5 target=editor debug_symbols=yes --clean
    scons -j"$(nproc)" platform=linux arch=x86_64 api_version=4.5 target=editor debug_symbols=yes

    cd addons/gamelogic/bin
    local target binary
    for target in debug release; do
        binary="libgamelogic.linux.${target}.x86_64.so"
        echo "Separating debug symbols for $binary..."
        objcopy --only-keep-debug "$binary" "$binary.debug"
        strip --strip-debug "$binary"
        objcopy --add-gnu-debuglink="$binary.debug" "$binary"

        echo "Creating source bundle for $binary..."
        sentry-cli debug-files bundle-sources "$binary.debug"
        test -s "$binary.src.zip"
    done
}

main "$@"
