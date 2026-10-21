#!/usr/bin/env pwsh
#Requires -Version 7.3
# Requires: Git, SCons, Python, MSVC compiler, sentry-cli.
# Run on Windows.

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$scriptDir = Split-Path -Parent (Resolve-Path $MyInvocation.MyCommand.Path)
Push-Location -Path "$scriptDir\.."
try {
    git submodule update --init --recursive -- addons/gamelogic/src/godot-cpp

    foreach ($target in @("debug", "release")) {
        Get-ChildItem -Path "addons/gamelogic/bin/gamelogic.windows.$target.x86_64.*" -File |
            Remove-Item
    }

    scons platform=windows arch=x86_64 target=template_release debug_symbols=yes
    scons platform=windows arch=x86_64 target=editor debug_symbols=yes

    Set-Location "addons/gamelogic/bin"
    foreach ($target in @("debug", "release")) {
        $name = "gamelogic.windows.$target.x86_64"
        sentry-cli debug-files bundle-sources "$name.pdb"
        if (!(Test-Path -Path "$name.src.zip" -PathType Leaf) -or (Get-Item "$name.src.zip").Length -eq 0) {
            throw "Missing source bundle for $name"
        }
    }
} finally {
    Pop-Location
}
