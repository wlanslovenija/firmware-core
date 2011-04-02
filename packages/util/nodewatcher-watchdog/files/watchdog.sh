#
# nodewatcher module
# WATCHDOG REPORTING MODULE
#

# Module metadata
MODULE_ID="core.watchdog"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  # DNS tests
  show_entry_from_file "dns.local" /var/dns_test_local "0"
  show_entry_from_file "dns.remote" /var/dns_test_remote "0"
}

