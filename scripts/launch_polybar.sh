#!/usr/bin/env bash

# Terminate already running polybar instances
killall -q polybar

# Wait until processes are shutdown
while pgrep -u $UID polybar >/dev/null; do sleep 1; done

# Launch top polybar
polybar top --config=$HOME/.polybar &

echo "Polybar launched..."
