#!/usr/bin/env pwsh
# Requires: Git, PowerShell, SCons, Python, MSVC compiler, sentry-cli.
# Run on Windows.

param (
	[string]$Ref = "master"
)

Set-StrictMode -Version latest

# Clone/update Godot Engine repo
if (-not (Test-Path -Path "godot")) {
	git clone --depth=1 --branch=$Ref https://github.com/godotengine/godot.git godot
	Set-Location -Path "godot"
}
else {
	Set-Location -Path "godot"

	# Clean old build
	# scons platform=windows target=template_release production=yes debug_symbols=yes separate_debug_symbols=yes --clean

	$branchExists = git ls-remote --heads origin ${Ref}
	if ($branchExists) {
		git fetch --depth=1 origin "refs/heads/${Ref}:refs/remotes/origin/${Ref}"
		git checkout origin/${Ref}
	} else {
		git fetch --depth=1 origin ${Ref}
		git checkout origin/${Ref}
	}
}


# ***** TEMPLATE *****

scons platform=windows target=template_release production=yes debug_symbols=yes separate_debug_symbols=yes

Move-Item -Path "bin/godot.windows.template_release.x86_64.exe" -Destination "../godot.windows.template_release.x86_64.exe" -Force
Move-Item -Path "bin/godot.windows.template_release.x86_64.pdb" -Destination "../godot.windows.template_release.x86_64.pdb" -Force

Set-Location -Path ".."

Compress-Archive -Path "godot.windows.template_release.x86_64.exe" -DestinationPath "godot.windows.template_release.x86_64.zip" -CompressionLevel Optimal -Force
Compress-Archive -Path "godot.windows.template_release.x86_64.pdb" -DestinationPath "godot.windows.template_release.x86_64.debug_symbols.zip" -CompressionLevel Optimal -Force

sentry-cli debug-files bundle-sources godot.windows.template_release.x86_64.pdb


# ***** EDITOR *****

Set-Location -Path "godot"

scons platform=windows target=editor production=yes debug_symbols=yes separate_debug_symbols=yes

Move-Item -Path "bin/godot.windows.editor.x86_64.exe" -Destination "../godot.windows.editor.x86_64.exe" -Force
Move-Item -Path "bin/godot.windows.editor.x86_64.pdb" -Destination "../godot.windows.editor.x86_64.pdb" -Force

Set-Location -Path ".."

Compress-Archive -Path "godot.windows.editor.x86_64.exe" -DestinationPath "godot.windows.editor.x86_64.zip" -CompressionLevel Optimal -Force

sentry-cli debug-files bundle-sources godot.windows.editor.x86_64.pdb

