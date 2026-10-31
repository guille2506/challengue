@echo off
title Notes (challengue) - CERRAR
cd /d %~dp0..

echo.
echo Cerrando backend (:8090) y frontend (:5173)...

taskkill /F /FI "WINDOWTITLE eq notes-backend*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq notes-frontend*" >nul 2>&1

set /a passes=0
:killloop
powershell -NoProfile -Command "Get-NetTCPConnection -LocalPort 8090,5173 -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object { try { Stop-Process -Id $_ -Force -ErrorAction Stop } catch {} }"
set /a passes+=1
powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort 8090,5173 -State Listen -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }"
if errorlevel 1 (
  if %passes% lss 3 (
    timeout /t 2 /nobreak >nul
    goto killloop
  )
  powershell -NoProfile -Command "Get-NetTCPConnection -LocalPort 8090,5173 -State Listen -ErrorAction SilentlyContinue | ForEach-Object { $p = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue; Write-Host ('AUN OCUPADO: puerto ' + $_.LocalPort + ' pid ' + $_.OwningProcess + ' ' + $p.ProcessName) }"
) else (
  echo       Puerto 8090 y 5173 liberados.
)

echo Bajando PostgreSQL (docker compose down)...
docker compose down

echo.
echo ============================================
echo   TODO CERRADO
echo ============================================
echo   Los datos de la base siguen guardados (volumen notes_pgdata).
echo   Para levantar de nuevo corre:  arranque-rapido\levantar_notes.bat
echo.
pause
