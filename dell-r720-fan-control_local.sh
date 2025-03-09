#!/bin/bash

ITERATION_NOW=0
ITERATION_MAX=4
ITERATION_SLEEP=10
DEFAULT_SPEED=20  # Default speed set to 20%

restore_dynamic_control() {
  echo "Restoring dynamic fan control"
  ipmitool raw 0x30 0x30 0x01 0x01 || echo "Failed to restore dynamic control"
}

set_speed() {
  if [ -z "$1" ]; then
    echo "No speed set"
    exit 2
  fi
  correction=-5
  speed_result=$(( $1 + correction ))
  speed_result=$(( speed_result < 0 ? 0 : speed_result )) # Ensure speed is not negative
  hex_speed=$(printf "%x" $speed_result)
  echo "Set speed: $speed_result% (0x$hex_speed)"
  ipmitool raw 0x30 0x30 0x01 0x00 || restore_dynamic_control
  ipmitool raw 0x30 0x30 0x02 0xff 0x$hex_speed || restore_dynamic_control
}

on_error() {
  restore_dynamic_control
}

trap "on_error" ERR  # Ensure errors trigger control restoration

detect_speed(){
  TEMP=$(ipmitool sdr type temperature | egrep "^Temp" | cut -d"|" -f5 | cut -d" " -f2 | sort -n -r | head -1)
  echo "Highest Temp: $TEMP C"

  if [[ "$TEMP" -ge "80" ]]; then
     set_speed 50
  elif [[ "$TEMP" -ge "76" ]]; then
     set_speed 45
  elif [[ "$TEMP" -ge "70" ]]; then
     set_speed 40
  elif [[ "$TEMP" -ge "67" ]]; then
     set_speed 34
  elif [[ "$TEMP" -ge "65" ]]; then
     set_speed 30
  elif [[ "$TEMP" -ge "62" ]]; then
     set_speed 27
  elif [[ "$TEMP" -ge "60" ]]; then
     set_speed 25
  elif [[ "$TEMP" -ge "50" ]]; then
     set_speed 23
  elif [[ "$TEMP" -ge "47" ]]; then
     set_speed 20
  elif [[ "$TEMP" -ge "40" ]]; then
     set_speed 17
  elif [[ "$TEMP" -ge "30" ]]; then
     set_speed 10
  elif [[ "$TEMP" -ge "20" ]]; then
     set_speed 7
  elif [[ "$TEMP" -ge "0" ]]; then
     set_speed 5
  else
     set_speed $DEFAULT_SPEED  # Apply default speed if no match
  fi
}

while :
do
  detect_speed
  ((ITERATION_NOW++))
  echo "Press CTRL+C to stop..."
  if ((ITERATION_NOW >= ITERATION_MAX))
  then
    break  # Exit the loop
  fi
  sleep $ITERATION_SLEEP
done
