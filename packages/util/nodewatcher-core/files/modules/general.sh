#
# nodewatcher module
# GENERAL STATISTICS
#

# Module metadata
MODULE_ID="core.general"
MODULE_SERIAL=1

#
# Report output function
#
report()
{
  show_entry_from_file "general.uuid" /etc/uuid "missing"
  show_entry_from_file "general.version" /etc/version "missing"
  show_entry "general.local_time" "`date +%s`"
  show_entry "general.uptime" "`cat /proc/uptime`"
  show_entry "general.loadavg" "`cat /proc/loadavg`"
  
  # Memory
  # TODO should be restructured into
  # general.memory.free
  # general.memory.buffers
  # general.memory.cache
  show_entry "general.memfree" "`cat /proc/meminfo | awk '/^MemFree/ { print $2 }'`"
  show_entry "general.buffers" "`cat /proc/meminfo | awk '/^Buffers/ { print $2 }'`"
  show_entry "general.cached" "`cat /proc/meminfo | awk '/^Cached/ { print $2 }'`"
}

