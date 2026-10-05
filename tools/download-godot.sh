#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<EOF
Usage: ${0##*/} [options]

Download one Godot build or symbol archive from getsentry/godot-builds.

Options:
  --release TAG       Release tag (required).
  --platform NAME     linux, windows, or macos (required).
  --arch ARCH         Package architecture, e.g. x86_64 or universal (required).
  --target TARGET     Package target (required).
                      Linux/Windows: editor, template_debug, template_release.
                      macOS: editor, templates.
  --sha SHA256        Expected archive SHA-256 checksum (required).
  --symbols           Select the debug symbols and source bundles archive.
  --output-dir DIR    Download destination (default: current directory).
  --extract           Extract the downloaded ZIP archive into the destination.
  -h, --help          Show this help and exit.
EOF
}

die() {
    echo "$*" >&2
    exit 1
}

main() {
    local release=""
    local platform=""
    local arch=""
    local target=""
    local expected_sha=""
    local suffix=".zip"
    local output_dir="."
    local extract=false
    local release_url package_prefix asset archive checksum

    while (($# > 0)); do
        case "$1" in
            --release | --platform | --arch | --target | --sha | --output-dir)
                if (($# < 2)) || [[ -z $2 || $2 == --* ]]; then
                    die "Missing value for $1"
                fi
                case "$1" in
                    --release) release=$2 ;;
                    --platform) platform=$2 ;;
                    --arch) arch=$2 ;;
                    --target)
                        [[ -z $target ]] || die "Specify --target only once."
                        target=$2
                        ;;
                    --sha) expected_sha=$2 ;;
                    --output-dir) output_dir=$2 ;;
                esac
                shift 2
                ;;
            --symbols)
                suffix=".debug-symbols.zip"
                shift
                ;;
            --extract)
                extract=true
                shift
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
    done

    [[ -n $release && -n $platform && -n $arch && -n $target && -n $expected_sha ]] ||
        die "Specify --release, --platform, --arch, --target, and --sha."

    [[ $release =~ ^godot-([0-9]+\.[0-9]+(\.[0-9]+)?-[^-]+)-(.+)$ ]] ||
        die "Expected release tag godot-VERSION-STATUS-BUILD, e.g. godot-4.5.2-stable-sentry.1."
    package_prefix="Godot_v${BASH_REMATCH[1]}_${BASH_REMATCH[3]}"

    [[ $expected_sha =~ ^[[:xdigit:]]{64}$ ]] || die "Expected a 64-digit SHA-256 checksum."
    expected_sha=$(printf '%s' "$expected_sha" | tr '[:upper:]' '[:lower:]')

    mkdir -p "$output_dir"
    release_url="https://github.com/getsentry/godot-builds/releases/download/${release}"
    asset="${package_prefix}_${target/_/.}.${platform}.${arch}${suffix}"
    archive="$output_dir/$asset"
    echo "Downloading $asset..."
    curl --fail --location --retry 3 --output "$archive" "$release_url/$asset"

    if command -v sha256sum >/dev/null 2>&1; then
        checksum=$(sha256sum -- "$archive")
    else
        checksum=$(shasum -a 256 -- "$archive")
    fi
    [[ ${checksum%% *} == "$expected_sha" ]] || die "SHA-256 mismatch for $asset."

    if [[ $extract == true ]]; then
        unzip -o "$archive" -d "$output_dir"
    fi
}

main "$@"
