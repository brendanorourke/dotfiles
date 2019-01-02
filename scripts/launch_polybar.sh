#!/usr/bin/env bash

declare -r PRIMARY_MONITOR=$(xrandr --query | grep '\bconnected' | grep '\bprimary\b' | awk '{print $1;}')

# Terminate already running polybar instances
killall -q polybar

# Wait until processes are shutdown
while pgrep -u $UID polybar >/dev/null; do sleep 1; done

# Launch top polybar
POLY_MONITOR=$PRIMARY_MONITOR bash -c 'polybar top --config=$HOME/.polybar &'

echo "Polybar launched..."
