#!/usr/bin/env pwsh

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

$component = Get-Content -Path "component.json" | ConvertFrom-Json
$pubSpecVersion = $(Get-Content -Path pubspec.yaml) -match "version:" -replace "version: " -replace "'" -replace "`""

if ($component.version -ne $pubSpecVersion) {
    throw "Versions in component.json and pubspec.yaml do not match"
}

# Login to pub.dev
if (-not [string]::IsNullOrEmpty($env:PUB_DEV_PUBLISH_ACCESS_TOKEN) -and`
    -not [string]::IsNullOrEmpty($env:PUB_DEV_PUBLISH_REFRESH_TOKEN) -and`
    -not [string]::IsNullOrEmpty($env:PUB_DEV_PUBLISH_TOKEN_ENDPOINT) -and`
    -not [string]::IsNullOrEmpty($env:PUB_DEV_PUBLISH_EXPIRATION)) {
    $pubCredentialsPath = "~/.pub-cache"
    # TODO: add path for windows
    $pubCredentials = @{
        "accessToken" = $env:PUB_DEV_PUBLISH_ACCESS_TOKEN;
        "refreshToken" = $env:PUB_DEV_PUBLISH_REFRESH_TOKEN;
        "tokenEndpoint" = $env:PUB_DEV_PUBLISH_TOKEN_ENDPOINT;
        "scopes" = @("https://www.googleapis.com/auth/userinfo.email","openid");
        "expiration" = [long]$env:PUB_DEV_PUBLISH_EXPIRATION
    }
    # Create credentials.json
    Write-Host "Creating '$pubCredentialsPath/credentials.json' with 'PUB_DEV_PUBLISH_*' env variables values..."
    if (-not (Test-Path -Path $pubCredentialsPath)) {
        $null = New-Item -ItemType Directory -Force -Path $pubCredentialsPath
    }
    $pubCredentials | ConvertTo-Json | Set-Content -Path "$pubCredentialsPath/credentials.json"
}

Write-Host "Formating code before publish..."
dart format lib test

# Publish to global repository
dart pub get
Write-Host "`nPushing package to pub.dev registry..."
try {
    dart pub publish -f 2>&1
}
catch {
    if ("$_".IndexOf("already exists") -gt 0) {
        Write-Host "Package $($component.name):$($component.version) already exists on pub.dev. Release skipped."
    }
    else {
        Write-Error "Release failed.`n$_"
    }
}
