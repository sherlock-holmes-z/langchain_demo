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

$pythonExecutable = Join-Path $environmentPath "python.exe"
if (-not (Test-Path -LiteralPath $pythonExecutable)) {
    throw "Conda 环境中未找到 python.exe"
}

# environment.yml 安装运行和开发依赖；这里只将当前项目注册为可编辑包。
& $pythonExecutable -m pip install --no-deps --editable $projectRoot
if ($LASTEXITCODE -ne 0) {
    throw "项目可编辑安装失败"
}

& $pythonExecutable -m ipykernel install `
    --user `
    --name $environmentName `
    --display-name "Python 3.12 (langchain-demo)"

Write-Host "环境初始化完成。执行: conda activate $environmentName"
