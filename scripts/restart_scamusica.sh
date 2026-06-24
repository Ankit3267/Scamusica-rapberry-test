#!/bin/bash
LOG_FILE="/var/log/scamusica/restart.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🔄 Restart initiated (PID $$)" >> "$LOG_FILE"

# Aggressive kill
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Killing old instances..." >> "$LOG_FILE"
pkill -9 -f 'com.musicplayer.scamusica.Main' 2>/dev/null || true
pkill -9 -f 'Scamusica' 2>/dev/null || true
pkill -9 -f 'scamusica.jar' 2>/dev/null || true
sleep 3

export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Launching wrapper..." >> "$LOG_FILE"

if [ -x "/opt/scamusica/lib/app/scamusica_wrapper.sh" ]; then
    nohup /opt/scamusica/lib/app/scamusica_wrapper.sh > /dev/null 2>&1 &
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Launched via wrapper" >> "$LOG_FILE"
elif [ -x "/opt/scamusica/bin/Scamusica" ]; then
    nohup /opt/scamusica/bin/Scamusica > /dev/null 2>&1 &
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Launched binary" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ No launcher found!" >> "$LOG_FILE"
    exit 1
fi