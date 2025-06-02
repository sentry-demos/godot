#!/usr/bin/env pwsh
# Requires: PowerShell, SCons, Python, MSVC compiler, sentry-cli.
# Run on Windows.

Set-StrictMode -Version latest

$startDir = Get-Location

$scriptDir = Split-Path -Parent (Resolve-Path $MyInvocation.MyCommand.Path)
Set-Location -Path "$scriptDir\.."

scons platform=windows target=template_release debug_symbols=yes

Set-Location -Path ".\addons\gamelogic\bin\"

sentry-cli debug-files bundle-sources gamelogic.windows.debug.x86_64.pdb
sentry-cli debug-files bundle-sources gamelogic.windows.release.x86_64.pdb

Set-Location -Path "$startDir"
