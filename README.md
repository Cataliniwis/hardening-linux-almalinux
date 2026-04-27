# 🔐 Hardening de Servidor Linux — Seguridad en Sistemas Operativos

[![AlmaLinux](https://img.shields.io/badge/AlmaLinux-9-0F4266?logo=almalinux&logoColor=white)](https://almalinux.org/)
[![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-Completed-success)]()

> Implementación integral de medidas de seguridad sobre un servidor Linux (AlmaLinux 9) en un escenario empresarial simulado, aplicando buenas prácticas de **hardening**, **principio de mínimo privilegio** y **monitoreo continuo**.

---

## 📋 Tabla de contenidos

- [Descripción del proyecto](#-descripción-del-proyecto)
- [Arquitectura](#-arquitectura)
- [Tecnologías utilizadas](#-tecnologías-utilizadas)
- [Servicios implementados](#-servicios-implementados)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Cómo replicar el laboratorio](#-cómo-replicar-el-laboratorio)
- [Capturas y evidencias](#-capturas-y-evidencias)
- [Aprendizajes](#-aprendizajes)
- [Autora](#-autora)

---

## 🎯 Descripción del proyecto

Este proyecto documenta el diseño e implementación de un entorno seguro para la empresa ficticia **Soluciones Digitales Innovar**, que requiere proteger su infraestructura ante el aumento del trabajo remoto y la comunicación entre sucursales.

Se configuró un servidor **AlmaLinux 9** y un cliente **Windows 10** dentro de una red privada virtualizada, aplicando políticas de seguridad sobre los principales servicios expuestos.

---

## 🗺️ Arquitectura

```
┌─────────────────────┐                ┌─────────────────────┐
│   Cliente Windows   │                │  Servidor AlmaLinux │
│                     │                │                     │
│   IP: 10.0.0.X/24   │ ◄────────────► │   IP: 10.0.0.Y/24   │
│                     │   Red privada  │                     │
│   - SSH client      │                │   - SSH (puerto X)  │
│   - Navegador       │                │   - Apache + Auth   │
│   - Proxy: server   │                │   - Squid Proxy     │
└─────────────────────┘                │   - Firewalld       │
                                       │   - Auditd          │
                                       └─────────────────────┘
```

> 🔒 **Nota:** Los direccionamientos IP reales del laboratorio fueron reemplazados por valores genéricos en este repositorio público.

---

## 🛠️ Tecnologías utilizadas

| Categoría | Herramienta |
|-----------|-------------|
| Sistema operativo servidor | AlmaLinux 9 |
| Sistema operativo cliente | Windows 10 |
| Virtualización | VMware Workstation |
| Acceso remoto | OpenSSH |
| Firewall | firewalld |
| Servidor web | Apache HTTP Server (httpd) |
| Proxy / filtrado web | Squid |
| Auditoría | auditd |
| Automatización | Bash + cron |
| Control de acceso avanzado | ACL (setfacl/getfacl) |
| Sistemas de archivos | ext4, XFS |

---

## 🔧 Servicios implementados

### 1️⃣ Configuración de red
- Asignación de IP estática mediante `nmcli` en el servidor.
- Configuración manual TCP/IP en cliente Windows.
- Verificación de conectividad punto a punto con `ping` e `ipconfig`.

### 2️⃣ Hardening SSH
- ❌ Deshabilitado el acceso remoto del usuario `root` (`PermitRootLogin no`).
- 🔄 Puerto SSH personalizado (no estándar) — registrado también en SELinux con `semanage`.
- 🌐 `ListenAddress` restringido únicamente a la IP del servidor.
- 👥 Acceso SSH limitado al grupo `remoto` mediante `AllowGroups`.
- 🔑 Autenticación por par de claves pública/privada (ed25519).
- 🔢 Máximo de **2 intentos fallidos** (`MaxAuthTries 2`).
- ⏱️ Cierre automático de sesión por **2 minutos de inactividad** (`ClientAliveInterval 120`).

### 3️⃣ Firewalld
- Apertura controlada de puertos para SSH personalizado y proxy Squid.
- **Rich rules** para bloquear direcciones IP específicas.
- Verificación de zonas activas y reglas con `firewall-cmd --list-all`.

### 4️⃣ Usuarios y grupos
| Grupo | Usuarios |
|-------|----------|
| `webmaster` | hugo, pedro |
| `contadores` | andrea, pablo |
| `gerente` | angel |
| `remoto` | *Todos los anteriores* |

### 5️⃣ Carpetas compartidas con permisos diferenciados
| Punto de montaje | FS | Tamaño | Propietario | Características |
|------------------|-----|--------|-------------|-----------------|
| `/webcorp` | ext4 | 10 GB | hugo:contadores | Directorio colaborativo (permisos `2770`, SGID) |
| `/contable` | XFS | 10 GB | andrea:andrea | ACL: `angel` con r-x |
| `/respaldo` | XFS | 10 GB | hugo:hugo | Permisos `750` |

### 6️⃣ Servidor web con autenticación
- Apache configurado para servir contenido desde `/webcorp`.
- **Autenticación básica** mediante `htpasswd` para el grupo `contadores`.
- Archivo de credenciales protegido fuera del DocumentRoot.

### 7️⃣ Proxy Squid
- Filtrado de URLs no permitidas (redes sociales, streaming, diarios electrónicos).
- ACLs para autorizar la red interna y exigir autenticación.
- Bloqueo evidenciado mediante respuestas `TCP_DENIED/403` en `access.log`.

### 8️⃣ Auditoría con `auditd`
- Detección de intentos fallidos de autenticación SSH.
- Análisis con `ausearch` y `aureport`.
- Auditoría de accesos web bloqueados a través de los logs de Squid.

### 9️⃣ Respaldos automatizados
- Script en Bash que comprime `/contable` con marca de fecha y hora.
- Tarea programada con **cron** para el día 30 de cada mes a las 22:30.
- Almacenamiento seguro en `/respaldo`.

---

## 📁 Estructura del repositorio

```
.
├── README.md                           # Este archivo
├── COMO_SUBIR_A_GITHUB.md              # Guía paso a paso para publicar el repo
├── LICENSE                             # Licencia MIT
├── .gitignore                          # Excluye archivos sensibles
├── docs/
│   └── INFORME_completo.pdf            # Informe técnico (con datos censurados)
├── scripts/
│   └── respaldo_contable.sh            # Script de respaldo mensual
└── configs/
    ├── sshd_config.example             # Config SSH endurecida
    ├── squid.conf.example              # Config Squid con ACLs
    ├── httpd-webcorp.conf.example      # VirtualHost con auth básica
    └── sitios_bloqueados.txt           # Lista de dominios bloqueados
```

---

## 🚀 Cómo replicar el laboratorio

### Requisitos previos
- Hipervisor (VMware Workstation, VirtualBox o similar).
- ISO de **AlmaLinux 9** (servidor).
- ISO de **Windows 10** (cliente).
- Recursos mínimos sugeridos:
  - Servidor: 2 GB RAM, 2 vCPU, 40 GB disco principal + 40 GB disco secundario.
  - Cliente: 4 GB RAM, 2 vCPU, 60 GB disco.

### Pasos generales

```bash
# 1. Actualizar el sistema
sudo dnf update -y

# 2. Instalar paquetes necesarios
sudo dnf install -y openssh-server httpd squid audit policycoreutils-python-utils

# 3. Habilitar servicios
sudo systemctl enable --now sshd httpd squid auditd firewalld

# 4. Aplicar las configuraciones de la carpeta /configs
# (revisar cada archivo .example y adaptarlo a tu entorno)
```

> 📖 Cada paso detallado está en la carpeta [`/docs`](./docs).

---

## 📸 Capturas y evidencias

El informe completo con capturas de pantalla, validaciones y resultados se encuentra en formato PDF:

📄 [`docs/INFORME_completo.pdf`](./docs/INFORME_completo.pdf) — *Datos sensibles (IPs, contraseñas, hashes, MAC, fingerprints SSH y nombres de usuario reales) fueron censurados con barras negras antes de la publicación.*

---

## 💡 Aprendizajes

A través de este proyecto se aplicaron y reforzaron los siguientes conceptos:

- ✅ **Defensa en profundidad**: combinación de varias capas de seguridad (red, SO, aplicación).
- ✅ **Principio de mínimo privilegio**: cada usuario y servicio con los permisos justos.
- ✅ **Trazabilidad y auditoría**: todo evento crítico queda registrado.
- ✅ **Automatización**: tareas repetitivas (respaldos) gestionadas con cron.
- ✅ **Hardening de SSH**: una de las superficies de ataque más comunes en servidores Linux.
- ✅ **Filtrado de contenido**: control del tráfico saliente con Squid.

---

## 👩‍💻 Autora

**Catalina Rebolledo**

Estudiante de la asignatura *Seguridad en Sistemas Operativos*  
Instituto Profesional San Sebastián — 2025

📫 *Si te interesó el proyecto, no dudes en darle ⭐ al repo o abrir un issue con sugerencias.*

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia MIT — ver el archivo [LICENSE](./LICENSE) para más detalles.

---

> ⚠️ **Disclaimer**: Este proyecto fue desarrollado con fines exclusivamente académicos. Las direcciones IP, nombres de usuario, contraseñas y otros datos sensibles fueron modificados o censurados antes de la publicación.
