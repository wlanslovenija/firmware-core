#
# nodewatcher module
# SOLAR REGULATOR REPORTING MODULE
#

# Module metadata
MODULE_ID="sensors.power.solar"
MODULE_SERIAL=1

# Configuration
SOLAR_MEASURE_CACHE="/var/nodewatcher.solar_measure"

#
# Gather statistics from the regulator
#
solar_measure_stats()
{
  if [ ! -x /usr/bin/solar ]; then
    return
  fi
  
  STATS="batvoltage solvoltage charge load state"
  if [ -c /dev/ttyS1 ]; then
    DEVICE="/dev/ttyS1"
  else
    DEVICE="/dev/tts/1"
  fi
  
  for entry in $STATS; do
    show_entry "solar.${entry}" "`/usr/bin/solar -d ${DEVICE} -b 9600 -p ${entry} 2> /dev/null`"
  done
}

#
# Report output function
#
report()
{
  if [ -f "$SOLAR_MEASURE_CACHE" ]; then
    cat "$SOLAR_MEASURE_CACHE"
  else
    solar_measure_stats > "$SOLAR_MEASURE_CACHE"
    cat "$SOLAR_MEASURE_CACHE"
  fi
}

#
# Handles periodic cache population (called via cron)
#
handle_solar_measure()
{
  solar_measure_stats > $SOLAR_MEASURE_CACHE
}

