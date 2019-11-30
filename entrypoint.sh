#!/bin/sh

env
set -x

find /home/user/data -prune -type d -empty | grep -q . && cp -aR /home/user/torch/* /home/user/data/
cd /home/user/data

rm -f /home/user/.Xauthority

eval xvfb-run $XVFB_OPTIONS -n 99 -l -f /home/user/.Xauthority -- wine64 Torch.Server.exe $@ &

PID=$!

while :; do
  eval x11vnc $VNC_OPTIONS -auth /home/user/.Xauthority -display :99.0
  sleep 2
done &

while :; do
  DISPLAY=:99.0 openbox
  sleep 2
done &

_term() {
  kill -15 $PID
  kill -2 $PID
}

trap _term SIGTERM SIGINT

wait $PID
