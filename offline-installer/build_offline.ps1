$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Root = $PSScriptRoot
$PayloadZip = Join-Path $Root 'payload\VeloVoice-1.3.5-exe-with-jre.zip'
$ExpectedSize = 46019358L
$ExpectedSha256 = 'f88524ada6c8d17c0421d98814c2e72967e0cd09ec881a92fa59580c6e612657'
$LicensePath = Join-Path $Root 'LICENSE-GPL-3.0.txt'
$IssPath = Join-Path $Root 'VeloVoice-1.3.5-Offline.iss'
$BuildRoot = Join-Path $Root 'build'
$StageRoot = Join-Path $BuildRoot 'stage'
$OutputRoot = Join-Path $Root 'dist'

if (-not (Test-Path -LiteralPath $PayloadZip)) {
    throw "缺少内置官方运行包：$PayloadZip。离线源码包应包含 payload\VeloVoice-1.3.5-exe-with-jre.zip。"
}
if (-not (Test-Path -LiteralPath $LicensePath)) {
    throw "缺少 GPL 许可证文件：$LicensePath"
}
$zip = Get-Item -LiteralPath $PayloadZip
if ([long]$zip.Length -ne $ExpectedSize) { throw "运行包大小校验失败：$($zip.Length)" }
$actualHash = (Get-FileHash -LiteralPath $PayloadZip -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actualHash -ne $ExpectedSha256) { throw "运行包 SHA-256 校验失败：$actualHash" }

if (Test-Path -LiteralPath $BuildRoot) { Remove-Item -LiteralPath $BuildRoot -Recurse -Force }
if (Test-Path -LiteralPath $OutputRoot) { Remove-Item -LiteralPath $OutputRoot -Recurse -Force }
New-Item -ItemType Directory -Path $StageRoot -Force | Out-Null
New-Item -ItemType Directory -Path $OutputRoot -Force | Out-Null
Expand-Archive -LiteralPath $PayloadZip -DestinationPath $StageRoot -Force

$appExe = Get-ChildItem -LiteralPath $StageRoot -Filter 'VeloVoice.exe' -File -Recurse | Select-Object -First 1
if ($null -eq $appExe) { throw '官方运行包内找不到 VeloVoice.exe。' }
$appRoot = $appExe.Directory.FullName
$javaExe = Get-ChildItem -LiteralPath $appRoot -Filter 'java.exe' -File -Recurse | Select-Object -First 1
if ($null -eq $javaExe) { throw '官方运行包内找不到 java.exe，不能生成自带 Java 的离线安装器。' }

$iscc = $env:INNO_SETUP_ISCC
if ([string]::IsNullOrWhiteSpace($iscc)) {
    $candidates = @(
        'C:\Program Files (x86)\Inno Setup 6\ISCC.exe',
        'C:\Program Files\Inno Setup 6\ISCC.exe'
    )
    $iscc = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}
if ([string]::IsNullOrWhiteSpace($iscc) -or -not (Test-Path -LiteralPath $iscc)) {
    throw '未找到 Inno Setup 6 的 ISCC.exe。请先安装 Inno Setup 6，或设置 INNO_SETUP_ISCC 环境变量。'
}

& $iscc "/DSourceDir=$appRoot" "/DLicenseFilePath=$LicensePath" "/O$OutputRoot" $IssPath
if ($LASTEXITCODE -ne 0) { throw "Inno Setup 编译失败，退出码：$LASTEXITCODE" }

$installer = Join-Path $OutputRoot 'VeloVoice-1.3.5-Offline-Setup-x64.exe'
if (-not (Test-Path -LiteralPath $installer)) { throw '编译结束但没有生成安装器。' }
if ((Get-Item -LiteralPath $installer).Length -lt 10000000) {
    throw '安装器体积异常偏小（小于 10 MB），疑似没有把运行组件封装进去。'
}
Write-Host "OFFLINE_INSTALLER=$installer"
Write-Host "INSTALLER_SIZE=$((Get-Item -LiteralPath $installer).Length)"
Write-Host "PAYLOAD_SHA256=$actualHash"
Write-Host 'BUILD_RESULT=PASS'