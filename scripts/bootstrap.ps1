[CmdletBinding()]
param(
    [switch]$Recreate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$environmentFile = Join-Path $projectRoot "environment.yml"
$environmentName = "langchain-demo"

function Get-CondaEnvironmentPath {
    # 使用目标环境自己的 Python 返回 sys.prefix，避免依赖 PowerShell 版本的 JSON 解析行为。
    $output = @(
        conda run --name $environmentName python -c "import sys; print(sys.prefix)" 2>$null
    )
    if ($LASTEXITCODE -ne 0) {
        return $null
    }

    $environmentPath = $output | Where-Object { $_.Trim() } | Select-Object -Last 1
    return $environmentPath.Trim()
}

$environmentPath = Get-CondaEnvironmentPath

if ($environmentPath -and $Recreate) {
    conda env remove --name $environmentName --yes
    $environmentPath = $null
}

if ($environmentPath) {
    conda env update --name $environmentName --file $environmentFile
}
else {
    conda env create --file $environmentFile
}

$environmentPath = Get-CondaEnvironmentPath
if (-not $environmentPath) {
    throw "Conda 环境 $environmentName 创建失败"
}

$uvExecutable = Join-Path $environmentPath "Scripts\uv.exe"
$pythonExecutable = Join-Path $environmentPath "python.exe"
if (-not (Test-Path -LiteralPath $uvExecutable)) {
    throw "Conda 环境中未找到 uv.exe"
}

$previousProjectEnvironment = $env:UV_PROJECT_ENVIRONMENT
try {
    # 显式指定 Conda 环境，避免 uv 在项目目录创建额外的 .venv。
    # --inexact 会保留 Conda 管理的 pip、setuptools、wheel 和 uv。
    $env:UV_PROJECT_ENVIRONMENT = $environmentPath
    & $uvExecutable sync `
        --project $projectRoot `
        --python $pythonExecutable `
        --extra dev `
        --frozen `
        --inexact
}
finally {
    $env:UV_PROJECT_ENVIRONMENT = $previousProjectEnvironment
}

& $pythonExecutable -m ipykernel install `
    --user `
    --name $environmentName `
    --display-name "Python 3.12 (langchain-demo)"

Write-Host "环境初始化完成。执行: conda activate $environmentName"
