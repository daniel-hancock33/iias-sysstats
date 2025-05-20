#!/bin/bash

trap 'echo "💥 Ctrl+C received, killing all jobs..."; kill 0; exit 1' SIGINT

CAPTUREID=$(date +%Y%m%d%H%M%S)
BASE_PATH="/opt/ibm/appliance/storage/scratch/iias-sysstat"
LIB_PATH="${BASE_PATH}/lib/sysutil_lib.sh"
OUTDIR="${BASE_PATH}/data"

echo "Starting database size capture @ ${CAPTUREID}"

source ${LIB_PATH} && collect_db_size_info ${OUTDIR} ${CAPTUREID}

echo "Starting system utilization capture @ ${CAPTUREID}"

for HOST in $(/opt/ibm/appliance/platform/xcat/scripts/xcat/display_nodes.py); do
  echo "→ ${HOST}: capturing sysutil..."
  ssh "${HOST}" "source ${LIB_PATH} && run_sysutil_capture ${CAPTUREID} ${OUTDIR}" &
done

wait
echo "✅ Completed all node captures for ${CAPTUREID}"