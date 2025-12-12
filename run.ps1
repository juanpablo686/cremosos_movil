# ===================================================================
# SCRIPT DE EJECUCIÓN AUTOMÁTICA - CREMOSOS E-COMMERCE
# ===================================================================
# Este script inicia automáticamente el backend y el frontend
# ===================================================================

Write-Host "
╔════════════════════════════════════════════════════════╗
║   🍚 CREMOSOS E-COMMERCE - INICIANDO PROYECTO          ║
╚════════════════════════════════════════════════════════╝
" -ForegroundColor Cyan

Write-Host "📋 Verificando requisitos..." -ForegroundColor Yellow

# Verificar si Node.js está instalado
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js detectado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js NO está instalado" -ForegroundColor Red
    Write-Host "   Descarga desde: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Verificar si Flutter está instalado
try {
    $flutterVersion = flutter --version | Select-String "Flutter" | Select-Object -First 1
    Write-Host "✅ Flutter detectado" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter NO está instalado" -ForegroundColor Red
    Write-Host "   Descarga desde: https://flutter.dev/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🔧 Verificando dependencias..." -ForegroundColor Yellow

# Verificar dependencias de Node.js
if (-Not (Test-Path "backend\node_modules")) {
    Write-Host "📦 Instalando dependencias de Node.js..." -ForegroundColor Yellow
    Set-Location backend
    npm install
    Set-Location ..
    Write-Host "✅ Dependencias de Node.js instaladas" -ForegroundColor Green
} else {
    Write-Host "✅ Dependencias de Node.js OK" -ForegroundColor Green
}

# Verificar dependencias de Flutter
if (-Not (Test-Path ".dart_tool")) {
    Write-Host "📦 Instalando dependencias de Flutter..." -ForegroundColor Yellow
    flutter pub get
    Write-Host "✅ Dependencias de Flutter instaladas" -ForegroundColor Green
} else {
    Write-Host "✅ Dependencias de Flutter OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "🚀 Iniciando servicios..." -ForegroundColor Cyan

# Iniciar servidor backend en nueva terminal
Write-Host "📡 Iniciando servidor API backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$PSScriptRoot\backend'; Write-Host '🍚 SERVIDOR BACKEND INICIANDO...' -ForegroundColor Cyan; node server.js"
)

# Esperar a que el servidor inicie
Write-Host "⏳ Esperando a que el servidor backend esté listo (5 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Verificar que el servidor esté corriendo
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/products" -TimeoutSec 5 -UseBasicParsing
    Write-Host "✅ Servidor backend está respondiendo" -ForegroundColor Green
} catch {
    Write-Host "⚠️  El servidor backend puede tardar un poco más..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
}

Write-Host ""
Write-Host "🌐 Iniciando aplicación Flutter..." -ForegroundColor Yellow

# Preguntar al usuario en qué plataforma ejecutar
Write-Host ""
Write-Host "Selecciona la plataforma:" -ForegroundColor Cyan
Write-Host "1. Chrome (Web) - Recomendado" -ForegroundColor White
Write-Host "2. Edge (Web)" -ForegroundColor White
Write-Host "3. Windows (Requiere Visual Studio con C++)" -ForegroundColor White
Write-Host ""

$option = Read-Host "Ingresa el número (1-3)"

switch ($option) {
    "1" {
        Write-Host "🌐 Ejecutando en Chrome..." -ForegroundColor Green
        flutter run -d chrome
    }
    "2" {
        Write-Host "🌐 Ejecutando en Edge..." -ForegroundColor Green
        flutter run -d edge
    }
    "3" {
        Write-Host "💻 Ejecutando en Windows..." -ForegroundColor Green
        flutter run -d windows
    }
    default {
        Write-Host "🌐 Ejecutando en Chrome (opción por defecto)..." -ForegroundColor Green
        flutter run -d chrome
    }
}

Write-Host ""
Write-Host "✅ ¡Proyecto iniciado correctamente!" -ForegroundColor Green
Write-Host ""
Write-Host "📌 INFORMACIÓN IMPORTANTE:" -ForegroundColor Cyan
Write-Host "   • API Backend: http://localhost:3000" -ForegroundColor White
Write-Host "   • Usuario test: admin@cremosos.com / 123456" -ForegroundColor White
Write-Host "   • Presiona 'q' en la terminal de Flutter para cerrar" -ForegroundColor White
Write-Host "   • El servidor backend seguirá corriendo en su terminal" -ForegroundColor White
Write-Host ""
