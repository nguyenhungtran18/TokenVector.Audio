# ====================================================================================================
# TokenVector.Audio - Standalone DLL & NuGet Package Builder
# 100% Automated Packaging directly from TokenVector (.tkv) sources
# ====================================================================================================

$ErrorActionPreference = "Stop"

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "BUILDING TOKENVECTOR.AUDIO DLL & NUPKG PACKAGE" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# 1. Locate tkvc compiler dynamically
$compiler = (Get-Command tkvc -ErrorAction SilentlyContinue)?.Source
if (-not $compiler -or -not (Test-Path $compiler)) {
    $candidates = @(
        "tkvc.exe",
        "$PSScriptRoot\tkvc.exe",
        "D:\TokenVector\3.code\dist\tkvc.exe",
        "..\dist\tkvc.exe",
        "$env:LOCALAPPDATA\TokenVector\tkvc.exe",
        "$env:USERPROFILE\.tkv\bin\tkvc.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) {
            $compiler = (Resolve-Path $c).Path
            break
        }
    }
}
if (-not $compiler -or -not (Test-Path $compiler)) {
    throw "TokenVector compiler (tkvc.exe) not found. Please ensure 'tkvc' is added to PATH or located in project directory."
}

Write-Host "[1/3] Compiling .tkv sources with tkvc ($compiler)..." -ForegroundColor Yellow
& $compiler build "test_audio_engine.tkv" --entry run --out "TokenVector.Audio.exe" | Out-Null

if (-not (Test-Path "TokenVector.Audio.il")) {
    throw "Compilation failed: TokenVector.Audio.il was not produced."
}

# 2. Locate ilasm.exe dynamically
$ilasm = (Get-Command ilasm -ErrorAction SilentlyContinue)?.Source
if (-not $ilasm -or -not (Test-Path $ilasm)) {
    $ilasmCandidates = @(
        "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe",
        "C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe"
    )
    foreach ($i in $ilasmCandidates) {
        if (Test-Path $i) {
            $ilasm = $i
            break
        }
    }
}
if (-not $ilasm -or -not (Test-Path $ilasm)) {
    throw "ECMA-335 CIL Assembler (ilasm.exe) not found on this system."
}

Write-Host "[2/3] Assembling CIL bytecode into TokenVector.Audio.dll..." -ForegroundColor Yellow

if (-not (Test-Path "bin\Release\net8.0")) { New-Item -ItemType Directory -Path "bin\Release\net8.0" -Force | Out-Null }
& $ilasm "TokenVector.Audio.il" /dll /output:"bin\Release\TokenVector.Audio.dll" | Out-Null
& $ilasm "TokenVector.Audio.il" /dll /output:"bin\Release\net8.0\TokenVector.Audio.dll" | Out-Null

# 3. Package into NuGet Package (.nupkg) including README.md & LICENSE
Write-Host "[3/3] Packaging into TokenVector.Audio.1.0.0.nupkg (with README.md and LICENSE)..." -ForegroundColor Yellow

Add-Type -AssemblyName System.IO.Compression.FileSystem

$pkgDir = (Join-Path (Get-Location) "bin\pkg_staging")
if (Test-Path $pkgDir) { Remove-Item -Path $pkgDir -Recurse -Force }
New-Item -ItemType Directory -Path "$pkgDir\lib\net8.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$pkgDir\lib\net48" -Force | Out-Null
New-Item -ItemType Directory -Path "$pkgDir\_rels" -Force | Out-Null
New-Item -ItemType Directory -Path "$pkgDir\package\services\metadata\core-properties" -Force | Out-Null

Copy-Item "TokenVector.Audio.nuspec" "$pkgDir\TokenVector.Audio.nuspec"
Copy-Item "README.md" "$pkgDir\README.md"
Copy-Item "LICENSE" "$pkgDir\LICENSE"
Copy-Item "bin\Release\net8.0\TokenVector.Audio.dll" "$pkgDir\lib\net8.0\TokenVector.Audio.dll"
Copy-Item "bin\Release\TokenVector.Audio.dll" "$pkgDir\lib\net48\TokenVector.Audio.dll"

$contentTypes = @"
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />
  <Default Extension="psmdcp" ContentType="application/vnd.openxmlformats-package.core-properties+xml" />
  <Default Extension="nuspec" ContentType="application/octet-stream" />
  <Default Extension="md" ContentType="text/markdown" />
  <Default Extension="dll" ContentType="application/octet-stream" />
  <Default Extension="txt" ContentType="text/plain" />
  <Default Extension="" ContentType="text/plain" />
</Types>
"@
[System.IO.File]::WriteAllText("$pkgDir\[Content_Types].xml", $contentTypes)

$rels = @"
<?xml version="1.0" encoding="utf-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="/package/services/metadata/core-properties/core.psmdcp" Id="R1" />
</Relationships>
"@
[System.IO.File]::WriteAllText("$pkgDir\_rels\.rels", $rels)

$coreProps = @"
<?xml version="1.0" encoding="utf-8"?>
<coreProperties xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.openxmlformats.org/package/2006/metadata/core-properties">
  <dc:creator>Tran Nguyen Hung</dc:creator>
  <dc:description>TokenVector.Audio - Industrial-Grade DSP &amp; Neural Audio Engine</dc:description>
  <dc:identifier>TokenVector.Audio</dc:identifier>
  <dc:title>TokenVector.Audio</dc:title>
  <version>1.0.0</version>
</coreProperties>
"@
[System.IO.File]::WriteAllText("$pkgDir\package\services\metadata\core-properties\core.psmdcp", $coreProps)

$targetNupkg = (Join-Path (Get-Location) "bin\Release\TokenVector.Audio.1.0.0.nupkg")
if (Test-Path $targetNupkg) { Remove-Item $targetNupkg -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($pkgDir, $targetNupkg)

Remove-Item -Path $pkgDir -Recurse -Force

Write-Host "==================================================================" -ForegroundColor Green
Write-Host "PACKAGING COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "  DLL:   bin\Release\TokenVector.Audio.dll" -ForegroundColor Green
Write-Host "  NUPKG: bin\Release\TokenVector.Audio.1.0.0.nupkg" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Green
