#!/bin/bash

# terminate already running bar intsances
killall -q polybar

# launch polybar using default config location
polybar example 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
