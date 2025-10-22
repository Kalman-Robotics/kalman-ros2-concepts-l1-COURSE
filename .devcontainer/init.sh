#!/bin/bash
set -e

echo "🔍 [Kalman] Verificando el estado del Docker Engine..."

# Verificar que Docker esté respondiendo
until timeout 5s docker info >/dev/null 2>&1; do
    echo "⚠️  Docker Desktop no está respondiendo."
    echo "👉 Asegúrate de que Docker Desktop esté abierto y despausado:"
    echo "   - Abre Docker Desktop en Windows."
    echo "   - Si ves el botón 'Resume' o 'Despausar', haz clic allí."
    echo "   - Espera a que el estado cambie a 'Running'."
    echo ""
    echo "Reintentando en 5 segundos..."
    sleep 5
done

echo "✅ Docker Engine está en ejecución."

# Verificar contenedores en ejecución
echo ""
echo "📦 [Kalman] Verificando contenedores activos..."
RUNNING_CONTAINERS=$(docker ps -q)

if [ -n "$RUNNING_CONTAINERS" ]; then
    echo "Se detectaron los siguientes contenedores en ejecución:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"

    echo ""
    echo "🧹 Deteniendo todos los contenedores para liberar recursos..."
    docker stop $(docker ps -q) >/dev/null 2>&1 || true
    echo "✅ Todos los contenedores fueron detenidos."
else
    echo "✅ No hay contenedores en ejecución."
fi

echo ""
echo "🚀 [Kalman] Entorno listo para ejecutar las simulaciones."
