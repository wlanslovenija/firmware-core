#
# nodewatcher module
# VPN MODULE
#

# Module metadata
MODULE_ID="core.vpn"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  show_entry "net.vpn.upload_limit" "`tc qdisc show dev tap0 2>/dev/null | grep -Eo '[0-9]+.?bit'`"
  show_entry "net.vpn.mac" "`ip link show dev tap0 2>/dev/null | tail -n 1 | awk '{ print $2 }'`"
}

