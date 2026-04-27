#!/bin/bash
# =============================================================================
# Script:        respaldo_contable.sh
# Descripción:   Respaldo mensual comprimido del directorio /contable
# Autor:         Catalina Rebolledo
# Programación:  cron - día 30 de cada mes a las 22:30
#                30 22 30 * * /usr/local/bin/respaldo_contable.sh
# =============================================================================

set -euo pipefail  # Salir ante errores, variables no definidas o fallos en pipes

# ----- Variables configurables -----
ORIGEN="/contable"
DESTINO="/respaldo"
FECHA=$(date +"%Y-%m-%d_%H-%M")
ARCHIVO="${DESTINO}/contable_${FECHA}.tar.gz"
LOG="/var/log/respaldo_contable.log"

# ----- Función de log -----
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

# ----- Validaciones -----
if [ ! -d "$ORIGEN" ]; then
    log "ERROR: El directorio origen $ORIGEN no existe."
    exit 1
fi

if [ ! -d "$DESTINO" ]; then
    log "ERROR: El directorio destino $DESTINO no existe."
    exit 1
fi

# ----- Ejecución del respaldo -----
log "Iniciando respaldo de $ORIGEN ..."

if tar -czf "$ARCHIVO" -C / "${ORIGEN#/}" 2>>"$LOG"; then
    TAMANO=$(du -h "$ARCHIVO" | cut -f1)
    log "Respaldo creado correctamente: $ARCHIVO ($TAMANO)"
else
    log "ERROR: Falló la creación del respaldo."
    exit 1
fi

# ----- Rotación opcional: conservar últimos 12 respaldos -----
cd "$DESTINO"
RESPALDOS_ANTIGUOS=$(ls -1t contable_*.tar.gz 2>/dev/null | tail -n +13)
if [ -n "$RESPALDOS_ANTIGUOS" ]; then
    echo "$RESPALDOS_ANTIGUOS" | xargs rm -f
    log "Respaldos antiguos eliminados (se conservan los 12 más recientes)."
fi

log "Proceso de respaldo finalizado exitosamente."
exit 0
