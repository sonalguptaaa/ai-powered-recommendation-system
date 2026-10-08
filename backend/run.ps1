# ============================================================
#  AI Recommendation Engine - launcher (PowerShell)
#  Finds a working Python and starts the FastAPI server.
# ============================================================
Set-Location -Path $PSScriptRoot
Write-Host ""
Write-Host "=== AI Recommendation Engine ===" -ForegroundColor Cyan
Write-Host "Looking for a suitable Python interpreter..."

# 1) Prefer project venv
if (Test-Path ".venv\Scripts\python.exe") {
    $py = ".venv\Scripts\python.exe"
    Write-Host "Using project virtualenv: $py" -ForegroundColor Green
}
else {
    # 2) Scan candidates; keep first one that already has the packages
    $candidates = @(
        "python", "py -3",
        "$env:LOCALAPPDATA\Programs\Python\Python314\python.exe",
        "$env:LOCALAPPDATA\Python\pythoncore-3.14-64\python.exe",
        "C:\Python314\python.exe", "C:\Python313\python.exe",
        "C:\Python312\python.exe", "C:\Python311\python.exe"
    )
    $py = $null
    foreach ($c in $candidates) {
        Write-Host "[check] $c"
        try {
            $null = & $c -c "import fastapi, pandas, sklearn, uvicorn" 2>$null
            if ($LASTEXITCODE -eq 0) { $py = $c; break }
        } catch { }
    }
}

if (-not $py) {
    Write-Host "`nERROR: No Python interpreter with the required packages was found.`n" -ForegroundColor Red
    Write-Host "Fix it in 3 steps:"
    Write-Host "  py -3 -m venv .venv"
    Write-Host "  .\.venv\Scripts\Activate.ps1"
    Write-Host "  pip install -r requirements.txt"
    Write-Host "Then run this file again.`n"
    exit 1
}

Write-Host "`nStarting server with: $py`n" -ForegroundColor Green
& $py -m uvicorn app:app --host 127.0.0.1 --port 8000
