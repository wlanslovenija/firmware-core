#
# Nodewatcher functions library
#
. /etc/functions.sh

get_client_subnets()
{
  client_subnets=
  
  config_cb() {
    local ipaddr netmask
    config_get enttype "$CONFIG_SECTION" TYPE

    if [[ "$enttype" == "alias" && "`echo $CONFIG_SECTION | grep subnet`" != "" ]]; then
      config_get ipaddr "$CONFIG_SECTION" ipaddr
      config_get netmask "$CONFIG_SECTION" netmask
      append client_subnets "$ipaddr/$netmask"
    fi
  }

  config_load network
}

get_local_ip()
{
  LOCAL_IP="`uci get network.subnet0.ipaddr`"
}

#
# A helper function for outputing key-value pairs in proper
# format.
#
show_entry()
{
  KEY="$1"
  VALUE="$2"
  
  echo "${KEY}: ${VALUE}"
}

#
# A helper function for outputting key-value pairs where
# value is read from a file if one exists, otherwise the
# default value is used.
#
show_entry_from_file()
{
  KEY="$1"
  FNAME="$2"
  DEF="$3"

  if [ -f "${FNAME}" ]; then
    show_entry "${KEY}" "`cat ${FNAME}`"
  else
    show_entry "${KEY}" "${DEF}"
  fi
}


