#!/usr/bin/env pwsh
# Requires: Git, PowerShell, SCons, Python, MSVC compiler (for building Godot)
# Run on Windows.

param (
	[string]$GodotBranch = "master"
)

# Clone Godot Engine source
git clone --depth=1 --branch=$GodotBranch https://github.com/godotengine/godot.git godot

Set-Location -Path "godot"

# Build Godot with SCons
scons platform=windows target=template_release production=yes debug_symbols=yes separate_debug_symbols=yes

Move-Item -Path "bin/godot.windows.template_release.x86_64.exe" -Destination "../godot.windows.template_release.x86_64.exe"
Move-Item -Path "bin/godot.windows.template_release.x86_64.pdb" -Destination "../godot.windows.template_release.x86_64.pdb"

Set-Location -Path ".."

# Create zip archives
Compress-Archive -Path "godot.windows.template_release.x86_64.exe" -DestinationPath "godot.windows.template_release.x86_64.zip" -CompressionLevel Optimal
Compress-Archive -Path "godot.windows.template_release.x86_64.pdb" -DestinationPath "godot.windows.template_release.x86_64.debug_symbols.zip" -CompressionLevel Optimal
