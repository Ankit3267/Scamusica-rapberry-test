#!/bin/bash
cvlc -I rc --rc-fake-tty "https://sample-videos.com/audio/mp3/crowd-cheering.mp3" < <(sleep 2; echo "get_length"; sleep 1; echo "get_time"; sleep 1; echo "status"; sleep 1; echo "quit")
