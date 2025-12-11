@echo off
REM Script para inicializar la base de datos usando SQLCMD
REM Este script funciona sin necesidad de habilitar TCP/IP

echo ========================================
echo  INICIALIZANDO BASE DE DATOS SQL SERVER
echo ========================================
echo.

echo [1/2] Creando tablas...
sqlcmd -S "JUANPABLO\SQLEXPRESS" -E -i "database\init-database.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: No se pudo conectar a SQL Server
    echo.
    echo Verifica:
    echo 1. Que SQL Server este corriendo: Get-Service -Name "MSSQL$SQLEXPRESS"
    echo 2. El nombre del servidor sea correcto: JUANPABLO\SQLEXPRESS
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo  TABLAS CREADAS EXITOSAMENTE!
echo ========================================
echo.
echo Ahora ejecuta: npm run seed-sqlcmd
echo Para poblar la base de datos con datos iniciales
echo.
pause
