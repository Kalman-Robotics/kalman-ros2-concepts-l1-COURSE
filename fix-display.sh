#!/bin/bash

# ==============================================================================
# Script de ayuda para problemas de Display (RViz/Gazebo)
# Solo usa esto si RViz o Gazebo no abren ventanas
# ==============================================================================

echo "============================================"
echo "  Fix Display - Kalman Robotics"
echo "============================================"
echo ""

# Detectar sistema operativo
if grep -qi microsoft /proc/version; then
    echo "✓ WSL2 detectado"
    echo ""

    # Verificar si existe WSLg (Windows 11)
    if [ -d "/mnt/wslg" ]; then
        echo "✓ Windows 11 con WSLg detectado"
        echo ""
        export DISPLAY=:0
        echo "Configurando DISPLAY=:0"
    else
        echo "✓ Windows 10 detectado (sin WSLg)"
        echo ""
        echo "⚠️  IMPORTANTE: Asegúrate de tener VcXsrv corriendo"
        echo "   Descarga: https://sourceforge.net/projects/vcxsrv/"
        echo ""
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
        echo "Configurando DISPLAY=$DISPLAY"
    fi

    echo ""
    echo "Configurando permisos de X11..."
    xhost +local:docker 2>/dev/null || xhost +local:root 2>/dev/null || echo "⚠️  xhost no disponible (puede que no sea necesario)"

else
    echo "✓ Linux nativo detectado"
    export DISPLAY=${DISPLAY:-:0}
    xhost +local:docker 2>/dev/null || true
fi

echo ""
echo "============================================"
echo "✅ Configuración completada"
echo "============================================"
echo ""
echo "Variables configuradas:"
echo "  DISPLAY=$DISPLAY"
echo ""
echo "Ahora ejecuta:"
echo "  docker-compose up"
echo ""
echo "Si aún tienes problemas, dentro del contenedor ejecuta:"
echo "  export LIBGL_ALWAYS_SOFTWARE=1"
echo "  rviz2"
echo ""
