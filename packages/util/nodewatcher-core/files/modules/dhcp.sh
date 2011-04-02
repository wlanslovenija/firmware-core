#
# nodewatcher module
# DHCP LEASE REPORTING MODULE
#

# Module metadata
MODULE_ID="core.dhcp"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  LEASES=$(cat /tmp/dhcp.leases | awk '{ print $3 }')
  client_id=0
  for lease in $LEASES; do
    show_entry "dhcp.client${client_id}.ip" $lease
    let client_id++
  done
}

