#
# nodewatcher module
# DIGITEMP ONE-WIRE TEMPERATURE SENSORS
#

# Module metadata
MODULE_ID="sensors.onewire.digitemp"
MODULE_SERIAL=1

# Configuration
DIGITEMP_HOME="/tmp/"
DIGITEMP_RC_FILE="$DIGITEMP_HOME.digitemprc"

#
# Report output function
#
report()
{
  if [ ! -x /usr/bin/digitemp_DS9097 ]; then
    return
  fi
  
  PWD=$(pwd)
  cd "$DIGITEMP_HOME"
  if [ ! -f "$DIGITEMP_RC_FILE" ]; then
    for file in "/dev/tts/1" "/dev/ttyS1" "/dev/tts/0" "/dev/ttyS0"; do
      if [ -c "$file" ]; then
        digitemp_DS9097 -q -s "$file" -i >/dev/null 2>/dev/null
      fi
    done
  fi
  if [ -f "$DIGITEMP_RC_FILE" ]; then
    /usr/bin/digitemp_DS9097 -a -q -o "environment.sensor%s.temp: %C
environment.sensor%s.serial: %R" 2>/dev/null
  fi
  cd "$PWD"
}

