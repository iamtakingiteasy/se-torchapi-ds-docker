#!/bin/sh

find /home/user/data -prune -type d -empty | grep -q . && cp -aR /home/user/torch/* /home/user/data/
cd /home/user/data

env
set -x

eval xvfb-run $XVFB_OPTIONS -n 99 -l -f /home/user/.Xauthority -- wine64 Torch.Server.exe $@ &

PID=$!

sleep 2

eval x11vnc $VNC_OPTIONS -auth /home/user/.Xauthority -display :99.0 &

sleep 2

DISPLAY=:99.0 openbox &

_term() {
  kill -15 $PID
  kill -2 $PID
}

trap _term SIGTERM SIGINT

wait $PID
