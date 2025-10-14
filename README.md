# Kalman Robotics - Curso ROS2 Humble

Entorno de desarrollo ROS2 con Gazebo y RViz2 para aprender robótica.

---

## 📋 Requisitos Previos

### 1. Instalar WSL2 y Docker Desktop

**WSL2** (Windows Subsystem for Linux):
```powershell
# En PowerShell como Administrador:
wsl --install
```
Reinicia tu PC y abre "Ubuntu" desde el menú de inicio.

**Docker Desktop**:
- Descarga: https://www.docker.com/products/docker-desktop/
- Instala y abre Docker Desktop
- Ve a Settings → Resources → WSL Integration
- Activa tu distribución Ubuntu
- Click "Apply & Restart"

---

## 🚀 Inicio Rápido (2 comandos)

```bash
# 1. Clonar el repositorio (en terminal Ubuntu/WSL)
git clone https://github.com/Kalman-Robotics/kalman-COURSE-ros2-concepts-l1.git
cd kalman-COURSE-ros2-concepts-l1

# 2. Iniciar el entorno (tarda 10-15 min la primera vez)
docker-compose up
```

**¡Listo!** Ya estás dentro del entorno ROS2 🎉

---

## 🧪 Probar que Funciona

Dentro del contenedor, prueba estos comandos:

```bash
# Ver que ROS2 funciona
ros2 topic list

# Lanzar simulación de TurtleBot3
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

**Para abrir otra terminal** en el mismo contenedor:
```bash
# En otra terminal de Ubuntu/WSL
docker exec -it ros2-dev bash
```

Luego dentro puedes ejecutar RViz2:
```bash
rviz2
```

---

## ⚠️ Problema: RViz/Gazebo no abren ventanas

### ¿Por qué pasa esto?

ROS2 corre en Linux pero tu pantalla es Windows. Necesitamos un "puente" para mostrar las ventanas.

### Solución depende de tu Windows:

#### ✅ Windows 11 (tiene WSLg integrado)

**Opción A - Automática**:
```bash
# En terminal Ubuntu/WSL, ANTES de docker-compose up:
export DISPLAY=:0
xhost +local:docker
```

**Opción B - Script de ayuda**:
```bash
./fix-display.sh
```

Luego ejecuta normalmente:
```bash
docker-compose up
```

#### ⚙️ Windows 10 (necesita VcXsrv)

**Paso 1**: Instalar VcXsrv (solo una vez)
- Descarga: https://sourceforge.net/projects/vcxsrv/
- Instala el programa

**Paso 2**: Ejecutar VcXsrv (cada vez que uses RViz/Gazebo)
- Abre XLaunch desde el menú de inicio
- Configuración:
  - Display number: `0`
  - Start no client: ✓
  - **Disable access control**: ✓ (IMPORTANTE)
  - Native opengl: ✓
- Click "Finish"
- Aparecerá un ícono "X" en la bandeja

**Paso 3**: Configurar en Ubuntu/WSL
```bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
xhost +local:docker
```

**Paso 4**: Iniciar contenedor
```bash
docker-compose up
```

#### 🆘 Modo de Emergencia (si nada funciona)

Dentro del contenedor:
```bash
export LIBGL_ALWAYS_SOFTWARE=1
rviz2  # o gazebo
```

Esto funcionará siempre pero será más lento.

---

## 📁 Estructura del Proyecto

```
kalman-COURSE-ros2-concepts-l1/
├── README.md              # Esta guía
├── docker-compose.yml     # Configuración del contenedor
├── fix-display.sh         # Script de ayuda para problemas de display
├── student_workspace/     # 👈 TU CARPETA DE TRABAJO
└── .devcontainer/         # Configuración para VSCode
```

### 💾 Tu Carpeta de Trabajo

Todo lo que guardes en `student_workspace/` **persiste** cuando cierres el contenedor.

**Ejemplo - Crear tu primer paquete**:
```bash
# Dentro del contenedor
cd /kalman_ws/src/student
ros2 pkg create --build-type ament_python mi_primer_robot

# Compilar
cd /kalman_ws
colcon build

# Usar
source install/setup.bash
ros2 run mi_primer_robot mi_nodo
```

---

## 🛠️ Comandos Útiles

### Gestión del Contenedor

```bash
# Iniciar contenedor (primera vez construye la imagen)
docker-compose up

# Detener contenedor (Ctrl+C o en otra terminal):
docker-compose down

# Abrir otra terminal en el mismo contenedor
docker exec -it ros2-dev bash

# Ver contenedores corriendo
docker ps

# Limpiar todo (¡cuidado! elimina la imagen)
docker-compose down --rmi all
```

### Trabajar con ROS2

```bash
# Compilar tu código
cd /kalman_ws
colcon build

# Compilar solo un paquete
colcon build --packages-select mi_paquete

# Recargar configuración
source install/setup.bash

# Ver nodos corriendo
ros2 node list

# Ver topics
ros2 topic list

# Ver info de un topic
ros2 topic echo /scan
```

---

## 🎓 Usar con Visual Studio Code

1. Instala la extensión "Dev Containers" en VSCode
2. Abre esta carpeta en VSCode: `File → Open Folder`
3. Presiona `F1` → escribe "Reopen in Container"
4. VSCode se reinicia dentro del contenedor con todo configurado

**Extensiones incluidas**:
- ROS
- C/C++ Tools
- Python
- CMake
- URDF Preview

---

## 🐛 Solución de Problemas Comunes

### ❌ "Docker not found" o "permission denied"

**Causa**: Docker no está instalado o no tiene permisos

**Solución**:
```bash
# Verifica que Docker Desktop esté corriendo (ícono en Windows)

# Reinicia la integración WSL:
# En PowerShell (Windows):
wsl --shutdown

# Abre Ubuntu de nuevo y prueba:
docker ps
```

### ❌ "No space left on device"

**Causa**: Docker se quedó sin espacio

**Solución**:
```bash
# Limpiar contenedores e imágenes no usadas
docker system prune -a
```

### ❌ "port is already allocated"

**Causa**: Ya hay un contenedor usando ese puerto

**Solución**:
```bash
docker-compose down
docker ps -a  # ver contenedores
docker rm -f ros2-dev  # forzar eliminación si es necesario
```

### ❌ "Permission denied" en student_workspace

**Solución**:
```bash
# En terminal Ubuntu/WSL (fuera del contenedor)
sudo chown -R $USER:$USER student_workspace
```

### ❌ RViz/Gazebo siguen sin abrir

1. **Verifica tu versión de Windows**:
   - Windows + R → escribe `winver` → Enter

2. **Windows 11**: Usa el script de ayuda:
   ```bash
   ./fix-display.sh
   docker-compose up
   ```

3. **Windows 10**: Asegúrate de que VcXsrv esté corriendo (ícono "X" en la bandeja)

4. **Último recurso** (dentro del contenedor):
   ```bash
   export LIBGL_ALWAYS_SOFTWARE=1
   rviz2
   ```

---

## 📚 Recursos de Aprendizaje

- [Documentación Oficial ROS2](https://docs.ros.org/en/humble/)
- [Tutoriales TurtleBot3](https://emanual.robotis.com/docs/en/platform/turtlebot3/quick-start/)
- [ROS2 CLI Cheat Sheet](https://github.com/ubuntu-robotics/ros2_cheats_sheet)

---

## 💡 Entender el Entorno

### ¿Qué incluye este contenedor?

- ✅ ROS2 Humble (versión LTS)
- ✅ Gazebo (simulador 3D)
- ✅ RViz2 (visualizador)
- ✅ TurtleBot3 (robot de ejemplo pre-instalado)
- ✅ Python 3.10 + colcon + rosdep
- ✅ Git, CMake, y herramientas de desarrollo

### ¿Dónde están los archivos?

Dentro del contenedor:
- `/simulation_ws` → Simulación de TurtleBot3 (solo lectura)
- `/kalman_ws` → Tu workspace principal
  - `/kalman_ws/src/student` → Aquí va tu código (persistente)

En tu computadora:
- `./student_workspace` → Se sincroniza con `/kalman_ws/src/student`

---

## ❓ FAQ (Preguntas Frecuentes)

**¿Cuánto espacio ocupa esto?**
- Aproximadamente 5-6 GB la primera vez

**¿Necesito internet siempre?**
- Solo la primera vez para descargar. Después puedes trabajar sin internet.

**¿Puedo usar esto en Mac/Linux?**
- Sí, pero no necesitas WSL. Instala Docker Desktop y ejecuta `docker-compose up`

**¿Qué es WSLg?**
- Windows Subsystem for Linux Graphics - permite mostrar ventanas de Linux en Windows 11 automáticamente

**¿Por qué Windows 10 necesita VcXsrv?**
- Windows 10 no tiene WSLg, entonces VcXsrv actúa como "servidor de ventanas"

**¿Los cambios se guardan al cerrar?**
- Sí, todo en `student_workspace/` se guarda permanentemente
- El resto del contenedor vuelve al estado original

**¿Cómo actualizo el entorno?**
```bash
docker-compose pull  # descargar última versión
docker-compose up --build  # reconstruir
```

---

## 🆘 ¿Necesitas Ayuda?

1. Revisa la sección de **Solución de Problemas** arriba
2. Si tienes problemas con GUI, ejecuta: `./fix-display.sh`
3. Abre un issue en GitHub con tu problema

---

**¡Happy Coding! 🤖**

*Kalman Robotics - 2025*
