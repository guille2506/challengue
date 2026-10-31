@echo off
title Notes (challengue) - LEVANTAR
cd /d %~dp0..

rem ---------------------------------------------------------------
rem Puertos elegidos para evitar colisiones con lo ya instalado:
rem   5432 = PostgreSQL 18 nativo  -> la base de Docker va en 5433
rem   8080 = Apache/pgAdmin (EDB)  -> el backend va en 8090
rem ---------------------------------------------------------------
set DB_NAME=notesdb
set DB_USER=notes
set DB_PASSWORD=notes
set DB_PORT=5433
set SERVER_PORT=8090
set DB_URL=jdbc:postgresql://localhost:5433/notesdb
set JAVA_TOOL_OPTIONS=-Duser.timezone=UTC
set VITE_BACKEND_URL=http://localhost:8090

echo.
echo ============================================
echo   Notes app - levantando el stack
echo ============================================
echo.

echo [1/4] PostgreSQL en Docker (:5433)...
docker compose up -d
if errorlevel 1 (
  echo.
  echo Detectado: conflicto con un contenedor notes-postgres de otro
  echo arranque anterior. Recreandolo no se borra el volumen de datos
  echo viejo, solo el contenedor huerfano.
  echo.
  choice /C SN /M "Recrear el contenedor notes-postgres para este proyecto"
  if errorlevel 2 (
    echo Cancelado por el usuario.
    pause
    exit /b 1
  )
  docker rm -f notes-postgres >nul 2>&1
  docker compose up -d
  if errorlevel 1 (
    echo ERROR: Docker no disponible o el contenedor sigue en conflicto.
    pause
    exit /b 1
  )
)

echo       Esperando la base de datos...
set /a tries=0
:waitdb
docker compose exec -T db pg_isready -U notes -d notesdb >nul 2>&1
if not errorlevel 1 goto dbok
set /a tries+=1
if %tries% geq 40 (
  echo ERROR: la base no respondio en 80 segundos.
  pause
  exit /b 1
)
timeout /t 2 /nobreak >nul
goto waitdb
:dbok
echo       Base de datos lista (notesdb en :5433).

echo [2/4] Backend Spring Boot :8090...
start "notes-backend :8090" cmd /k "cd /d %~dp0..\backend && mvnw.cmd -q spring-boot:run"

echo       Esperando el API...
set /a tries=0
:waitapi
curl -sf http://localhost:8090/api/categories >nul 2>&1
if not errorlevel 1 goto apiok
set /a tries+=1
if %tries% geq 60 (
  echo ERROR: el backend no respondio. Mirando la ventana notes-backend habra el detalle.
  pause
  exit /b 1
)
timeout /t 2 /nobreak >nul
goto waitapi
:apiok
echo       Backend listo en http://localhost:8090/api/notes

echo [3/4] Frontend React :5173...
cd /d %~dp0..\frontend
if not exist node_modules (
  echo       Instalando dependencias npm... (solo la primera vez, tarda un poco)
  call npm install --no-audit --no-fund
)
start "notes-frontend :5173" cmd /k "cd /d %~dp0..\frontend && npm run dev"
cd /d %~dp0..

echo       Esperando el frontend...
set /a tries=0
:waitfe
curl -sf http://localhost:5173 >nul 2>&1
if not errorlevel 1 goto feok
set /a tries+=1
if %tries% geq 30 (
  echo ERROR: el frontend no abrio. Mirando la ventana notes-frontend habra el detalle.
  pause
  exit /b 1
)
timeout /t 2 /nobreak >nul
goto waitfe
:feok

echo [4/4] Abriendo el navegador...
start http://localhost:5173

echo.
echo ============================================
echo   LISTO
echo   Frontend : http://localhost:5173
echo   API      : http://localhost:8090/api/notes
echo   Base     : Docker postgres en :5433
echo ============================================
echo.
echo   Las ventanas notes-backend y notes-frontend muestran los logs.
echo   Para cerrar TODO corre:  arranque-rapido\cerrar_notes.bat
echo.
pause
