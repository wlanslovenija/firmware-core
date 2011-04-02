#
# nodewatcher module
# WIFI STATISTICS
#

# Module metadata
MODULE_ID="core.wireless"
MODULE_SERIAL=1

#
# Helper function for displaying wifi-related entries; uses the
# global variable "iface_name" for the interface name
#
show_wifi_entry()
{
  local key="$1"
  local value="$2"
  local prefix
  
  if [ "${iface_name}" != "" ]; then
    prefix="wireless.radios.${iface_name}"
  else
    prefix="wifi"
  fi
  
  show_entry "${prefix}.${key}" "${value}" 
}

#
# Reports data for a specific wireless interface
#
show_interface()
{
  local iface="$1"
  iface_name="$2"
  local iwace_data="`iwconfig ${iface} 2>/dev/null`"
  local iface_data="`ifconfig ${iface} 2>/dev/null`"
  
  # Display interface information
  show_wifi_entry "bssid" "`echo "${iwace_data}" | grep Cell | awk '{ print $5 }'`"
  show_wifi_entry "essid" "`echo "${iwace_data}" | grep ESSID | awk '{ split($4, a, \"\\"\"); printf(\"%s\", a[2]); }' `"
  show_wifi_entry "frequency" "`echo "${iwace_data}" | grep Frequency | awk '{ print $2 }' | cut -d ':' -f 2`"
  
  # Commented out because of the iwlist (madwifi) memory leak, #209
  #show_entry "wifi.cells" "`iwlist scan 2>/dev/null | grep 'Cell.*Address' | wc -l`"
  show_wifi_entry "mac" "`echo "${iface_data}" | grep HWaddr | awk '{ print $5 }' | head -n 1`"
  show_wifi_entry "rts" "`echo "${iwace_data}" | grep -Eo 'RTS thr.(off|[0-9]+ B)' | grep -Eo 'off|[0-9]+'`"
  show_wifi_entry "frag" "`echo "${iwace_data}" | grep -Eo 'Fragment thr.(off|[0-9]+ B)' | grep -Eo 'off|[0-9]+'`"
  
  # Show multicast rate only for atheros devices
  # FIXME should not be hardcoded
  if [[ "${iface}" == "ath0" ]]; then
    show_wifi_entry "mcast_rate" "`iwpriv ${iface} get_mcast_rate | grep -Eo 'get_mcast_rate:[0-9]+' | cut -d ':' -f 2`"
  fi
  
  # Report current bitrate
  local bitrate="`iwlist ${iface} bitrate | grep -Eo 'Current Bit Rate:[0-9]+' | cut -d ':' -f 2`"
  if [[ "${bitrate}" == "0" ]]; then
    bitrate="`iwpriv ${iface} get_rate11g | grep -Eo 'get_rate11g:[0-9]+' | cut -d ':' -f 2`"
  fi
  show_wifi_entry "bitrate" "${bitrate}"
  
  # Report signal and noise levels
  local lqn_data="`cat /proc/net/wireless | grep ${iface}`"
  show_wifi_entry "signal" "`echo ${lqn_data} | awk '{ print $4 }' | cut -d '.' -f 1`"
  show_wifi_entry "noise" "`echo ${lqn_data} | awk '{ print $5 }' | cut -d '.' -f 1`"
}

#
# Report output function
#
report()
{
  local radios=$(cat /proc/net/wireless | grep ':' | awk '{ print $1 }' | cut -d ':' -f 1)
  for radio in $radios; do
    show_interface "${radio}" "${radio}"
  done
  show_entry_from_file "wireless.errors" /tmp/wifi_errors_counter "0"
  
  # For backward compatibility include old format output as well
  # TODO remove this when monitor is updated and bump MODULE_SERIAL
  local wifi_iface="`iwconfig 2>/dev/null | grep ESSID | awk '{ print $1 }' | head -n 1`"
  show_interface "${wifi_iface}" ""
  show_entry_from_file "wifi.errors" /tmp/wifi_errors_counter "0"
}

