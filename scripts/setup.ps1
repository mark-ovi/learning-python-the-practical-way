<#
.SYNOPSIS
  Setup project venv and install requirements (PowerShell).
#>

param(
  [string]$VenvPath = ".venv",
  [string]$PythonVersion = "3.14",
  [switch]$Force
)

function Resolve-HostPythonForVersion {
  $pyCmd = Get-Command py -ErrorAction SilentlyContinue
  if ($pyCmd) {
    $probe = & $pyCmd.Source "-$PythonVersion" "-c" "import sys; print(sys.executable)" 2>$null
    if ($LASTEXITCODE -eq 0 -and $probe) { return "py" }
  }
  return $null
}

$hostPython = Resolve-HostPythonForVersion
if (-not $hostPython) {
  Write-Error "Python $PythonVersion not found. Install Python $PythonVersion and ensure the Windows 'py' launcher is available."
  exit 1
}

$venvCreatedThisRun = $false

if (Test-Path $VenvPath) {
  if ($Force) {
    Write-Output "$VenvPath exists; removing due to -Force..."
    Remove-Item -Recurse -Force $VenvPath
  } else {
    Write-Output "$VenvPath already exists — skipping venv creation. Use -Force to rebuild."
  }
}

if (-not (Test-Path $VenvPath)) {
  if ($hostPython -eq "py") {
    & py "-$PythonVersion" "-m" "venv" $VenvPath
  } else {
    & $hostPython "-m" "venv" $VenvPath
  }
  Write-Output "Created $VenvPath using Python $PythonVersion"
  $venvCreatedThisRun = $true
} else {
  Write-Output "Using existing $VenvPath"
}

$venvPython = Join-Path $VenvPath "Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
  Write-Error "python not found in venv at $venvPython. Activate venv and run pip manually."
  exit 1
}

& $venvPython -m pip install --upgrade pip setuptools wheel

if (Test-Path "requirements.txt") {
  & $venvPython -m pip install -r requirements.txt
} else {
  Write-Output "No requirements.txt found — nothing to install"
}

$activate = Join-Path $VenvPath "Scripts\Activate.ps1"
if (Test-Path $activate) {
  Write-Output "To activate, run: . $activate"
} else {
  Write-Warning "Activate script not found at $activate"
}

Write-Output "Setup complete."
