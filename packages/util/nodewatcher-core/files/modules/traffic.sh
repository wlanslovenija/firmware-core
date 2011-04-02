#
# nodewatcher module
# INTERFACE TRAFFIC STATISTICS
#

# Module metadata
MODULE_ID="core.traffic"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  IFACES=`cat /proc/net/dev | awk -F: '!/\|/ { gsub(/[[:space:]]*/, "", $1); split($2, a, " "); printf("%s=%s=%s ", $1, a[1], a[9]) }'`
  
  # Output entries for each interface
  for entry in $IFACES; do
    iface=`echo $entry | cut -d '=' -f 1`
    rcv=`echo $entry | cut -d '=' -f 2`
    xmt=`echo $entry | cut -d '=' -f 3`
    
    if [[ "$iface" != "lo" && "$iface" != "wmaster0" ]]; then
      if [[ "`ip link show ${iface} | head -n 1 | grep UP`" != "" ]]; then
        show_entry "iface.${iface}.down" $rcv
        show_entry "iface.${iface}.up" $xmt
      fi
    fi
  done
}

