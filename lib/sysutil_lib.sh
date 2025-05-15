#!/bin/bash

run_sysutil_capture() {
  CAPTURED_TS="$1"
  OUTDIR="$2/${CAPTURED_TS}"
  LOCALHOST=$(hostname)

  mkdir -p "$OUTDIR"

  echo "Captured: ${CAPTURED_TS}" > "${OUTDIR}/captured.log"
  echo "OUTDIR:   ${OUTDIR}" >> "${OUTDIR}/captured.log"
  echo "HOSTNAME: ${LOCALHOST}" >> "${OUTDIR}/captured.log"
  ls -l /var/log/sa/sa[0-9][0-9] >> "${OUTDIR}/captured.log"

  declare -A METRICS
  METRICS=(
    [cpu]="-u"
    [mem]="-r"
    [io]="-d"
    [iotps]="-b"
    [net]="-n DEV"
    [swp]="-W"
    [swps]="-S"
  )

  for file in /var/log/sa/sa[0-9][0-9]; do
    FILENAME=$(basename "$file")
    SUCCESS_COUNT=0
    SKIPPED_COUNT=0
    TS=""

    for metric in "${!METRICS[@]}"; do
      FLAG="${METRICS[$metric]}"

      # Try sadf first
      if LC_ALL=C sadf -C -f "$file" -- $FLAG > /dev/null 2>&1; then
        TS=$(sadf -d -f "$file" -- $FLAG | awk -F';' 'NR==2 {print $1}' | cut -d'T' -f1)
        outprefix="${LOCALHOST}.${TS}"
        echo "[INFO] ${metric^^} via sadf: ${FILENAME} (TS: ${TS})" >> "${OUTDIR}/captured.log"

        LC_ALL=C sadf -C -f "$file" -- $FLAG \
          | sed "s/^/${LOCALHOST},${TS},/" \
          > "${OUTDIR}/${outprefix}.${metric}.csv"

        ((SUCCESS_COUNT++))

      # Fallback to sar
      elif sar $FLAG -f "$file" > /dev/null 2>&1; then
        TS=$(sar -f "$file" | head -1 | awk '{print $4}' | awk -F '/' '{print $3"-"$1"-"$2}')
        outprefix="${LOCALHOST}.${TS}"
        echo "[INFO] ${metric^^} via sar: ${FILENAME} (TS: ${TS})" >> "${OUTDIR}/captured.log"

        sar $FLAG -f "$file" \
          | sed '$d' \
          | tr -s '[:blank:]' \
          | sed -n '1h;2,$H;${g;s/ /,/g;p}' \
          | sed '/Average:/d' \
          | sed "s/^/${LOCALHOST},${TS},/" \
          > "${OUTDIR}/${outprefix}.${metric}.dat"

        ((SUCCESS_COUNT++))

      else
        echo "[WARN] ${metric^^}: Unreadable in $FILENAME" >> "${OUTDIR}/captured.log"
        ((SKIPPED_COUNT++))
      fi
    done

    if [[ $SUCCESS_COUNT -eq 0 && $SKIPPED_COUNT -eq 0 ]]; then
      echo "🔄 $FILENAME on $LOCALHOST... skipped (unreadable)"
    else
      echo "🔄 $FILENAME on $LOCALHOST... ${SUCCESS_COUNT} metrics OK, ${SKIPPED_COUNT} skipped"
    fi

    echo "" >> "${OUTDIR}/captured.log"
  done
}

