#!/bin/bash
cd /opt/scamusica/lib/app

exec /opt/scamusica/lib/runtime/bin/java \
    -Xmx512m -Xms256m \
    -Djna.library.path=/opt/scamusica/lib/app/lib/vlc \
    -DVLC_PLUGIN_PATH=/opt/scamusica/lib/app/lib/vlc/plugins \
    --module-path /opt/scamusica/lib/runtime/lib \
    -cp "Scamusica-*.jar" \
    com.musicplayer.scamusica.Main "$@"