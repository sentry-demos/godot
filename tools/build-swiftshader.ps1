#!/usr/bin/env pwsh
# Build SwiftShader -- CPU-based implementation of the Vulkan API.
# Requires: Git, PowerShell, MSVC compiler, CMake, sentry-cli.
# Works with CMake 3.31.7, doesn't work with CMake 4.0.
# Run on Windows.

param (
	[string]$Ref = "master"
)

Set-StrictMode -Version latest

$startDir = Get-Location
$scriptDir = Split-Path -Parent (Resolve-Path $MyInvocation.MyCommand.Path)
Set-Location "$scriptDir"

# Clone/update Swiftshader repo
if (-not (Test-Path -Path "swiftshader")) {
	git clone --depth=1 --branch=$Ref https://github.com/google/swiftshader.git swiftshader
}

Set-Location -Path "swiftshader"

cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build --parallel --config RelWithDebInfo

Move-Item -Path "build/RelWithDebInfo/vk_swiftshader.dll" -Destination "../vulkan-1.dll" -Force
Move-Item -Path "build/RelWithDebInfo/vk_swiftshader.pdb" -Destination "../vulkan-1.pdb" -Force

Set-Location -Path "$startDir"
