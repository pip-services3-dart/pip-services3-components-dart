#!/usr/bin/env pwsh

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

$component = Get-Content -Path "component.json" | ConvertFrom-Json
$version = (Get-Content -Path pubspec.yaml | ConvertFrom-yaml ).version

if ($component.version -ne $version) {
    throw "Versions in component.json and pubspec.yaml do not match"
}

Write-Output "Formating code before publish"
dartfmt -w lib test

# Publish to global repository
Write-Output "Pushing package to [pub.dev] registry"
pub publish
