# Guía rápida — Subir el proyecto a GitHub

Esta guía te lleva paso a paso desde cero hasta tener tu repo publicado.

## 1. Crear cuenta en GitHub (si aún no tienes)

Ve a https://github.com y regístrate con tu correo.

## 2. Instalar Git en tu computadora

- **Windows:** descarga e instala Git desde https://git-scm.com/download/win
- **macOS:** `brew install git` o descarga desde https://git-scm.com
- **Linux:** `sudo dnf install git` o `sudo apt install git`

Configura tu identidad (solo la primera vez):

```bash
git config --global user.name "Catalina Rebolledo"
git config --global user.email "tu_correo@example.com"
```

## 3. Crear un nuevo repositorio en GitHub

1. Inicia sesión en GitHub.
2. Haz clic en el botón verde **"New"** o ve a https://github.com/new
3. Llena los campos:
   - **Repository name:** `hardening-linux-almalinux` (o el nombre que prefieras)
   - **Description:** "Proyecto académico de hardening de servidor Linux: SSH, firewalld, Squid, auditd, Apache con autenticación y respaldos automatizados."
   - **Public** ✅ (para que sea visible en tu portfolio)
   - **NO marques** "Add a README" (ya tienes uno)
   - **NO marques** "Add .gitignore" (ya tienes uno)
4. Haz clic en **"Create repository"**.

## 4. Subir el proyecto desde tu computadora

Abre una terminal en la carpeta del proyecto y ejecuta:

```bash
# 1. Inicializar el repo local
git init

# 2. Agregar todos los archivos
git add .

# 3. Hacer el primer commit
git commit -m "Primer commit: proyecto de hardening Linux"

# 4. Renombrar la rama principal a main (estándar moderno)
git branch -M main

# 5. Conectar con tu repo remoto en GitHub
# (reemplaza TU_USUARIO con tu nombre de usuario de GitHub)
git remote add origin https://github.com/TU_USUARIO/hardening-linux-almalinux.git

# 6. Subir el proyecto
git push -u origin main
```

GitHub te pedirá tus credenciales. Si tienes activada la autenticación de dos factores, debes generar un **Personal Access Token** en GitHub (Settings → Developer settings → Personal access tokens) y usarlo como contraseña.

## 5. Verificar que se subió bien

Refresca la página de tu repositorio en GitHub. Deberías ver:
- ✅ El README.md renderizado en la página principal con badges y tabla de contenidos
- ✅ La estructura de carpetas (`/configs`, `/scripts`, `/docs`)
- ✅ El archivo LICENSE

## 6. Agregar tópicos al repo (mejora la visibilidad)

En la página principal de tu repo, haz clic en el ⚙️ junto a "About" y agrega tópicos como:
- `linux`
- `cybersecurity`
- `hardening`
- `ssh`
- `squid-proxy`
- `firewall`
- `bash`
- `system-administration`
- `almalinux`

## 7. Consejos para que el repo se vea profesional

- ✅ Agrega una **descripción corta** y una URL si tienes (paso 6).
- ✅ Cuelga una **captura del README** en la sección "About" si quieres un look extra.
- ✅ Si actualizas algo, haz commits frecuentes con mensajes descriptivos:
  ```bash
  git add .
  git commit -m "Mejorar configuración de Squid con nuevas ACLs"
  git push
  ```
- ✅ Considera fijar este repo en tu perfil para que aparezca destacado.

## 🎯 ¡Listo!

Tu proyecto ya forma parte de tu portfolio público en GitHub. Compártelo en tu CV, LinkedIn o donde quieras mostrar tu trabajo.
