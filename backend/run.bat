@echo off
REM ============================================================
REM  AI Recommendation Engine - one-click launcher (Windows)
REM  Finds a working Python and starts the FastAPI server.
REM ============================================================
setlocal
cd /d "%~dp0"

echo.
echo === AI Recommendation Engine ===
echo Looking for a suitable Python interpreter...
echo.

REM 1) Prefer the project's own venv if it exists
if exist ".venv\Scripts\python.exe" (
    echo [1] Using project virtualenv:  .venv\Scripts\python.exe
    set "PY=.venv\Scripts\python.exe"
    goto :run
)

REM 2) Otherwise scan known locations for a Python that HAS the packages
set "CANDIDATES=python;py -3;C:\Users\%USERNAME%\AppData\Local\Python\pythoncore-3.14-64\python.exe;C:\Python314\python.exe;C:\Python313\python.exe;C:\Python312\python.exe;C:\Python311\python.exe"

for %%P in (%CANDIDATES%) do (
    echo [check] %%P
    %%P -c "import fastapi, pandas, sklearn, uvicorn" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo [ok] Using interpreter: %%P
        echo [ok] If this is a bare 'python'/'py' and deps are missing, run:
        echo [ok]     %%P -m pip install -r requirements.txt
        echo.
        %%P -m uvicorn app:app --host 127.0.0.1 --port 8000
        goto :end
    )
)

echo.
echo ERROR: No Python interpreter with the required packages was found.
echo.
echo Fix it in 3 steps:
echo   1. py -3 -m venv .venv
echo   2. .venv\Scripts\activate
echo   3. pip install -r requirements.txt
echo Then run this file again.
echo.

:end
endlocal
