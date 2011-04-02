#
# Common functions for nodewatcher OLSR actions.
#
MARK_TRAFFIC="/tmp/traffic_redirection_enabled"
MARK_DNS="/tmp/dns_redirection_enabled"
MARK_DNS_DOWN="/tmp/dns_servers_down"
LOSS_COUNTER="/tmp/loss_counter"

. /lib/nodewatcher/common.sh

iptables_retry()
{
  RESULT=0
  for _ in $(seq 1 5); do
    iptables $@ 2>&1
    RESULT=$?
    
    if [[ "${RESULT}" == "4" ]]; then
      # Error code 4 indicates a temporary resource problem, retry
      sleep 1
    else
      break
    fi
  done
  
  if [[ "${RESULT}" == "4" ]]; then
    logger "nodewatcher: Unable to modify netfilter rules, state is undefined, rebooting"
    reboot
  elif [[ "${RESULT}" != "0" ]]; then
    # Some other error has ocurred, report it so nodewatcher will notice it
    echo "${RESULT}" > /tmp/iptables_redirection_problem
  fi
}

generate_rules()
{
  NF_ACTION="$1"
  
  # Generate rules for all subnets
  get_local_ip
  get_client_subnets
  for subnet in $client_subnets; do
    iptables_retry -t nat -${NF_ACTION} PREROUTING -p tcp --dport 80 -s ${subnet} -d ${LOCAL_IP} -j CLIENT_REDIRECT
    iptables_retry -t nat -${NF_ACTION} PREROUTING -p tcp --dport 80 -s ${subnet} ! -d 10.254.0.0/16 -j CLIENT_REDIRECT
  done
}

start_traffic_redirection()
{
  logger "nodewatcher: Starting traffic redirection"
  # Insert iptables rule to forward incoming HTTP traffic (only from client subnet)
  iptables_retry -t nat -N CLIENT_REDIRECT
  generate_rules "I"
  get_local_ip
  iptables_retry -t nat -A CLIENT_REDIRECT -p tcp --dport 80 -j DNAT --to-destination ${LOCAL_IP}:2051
  iptables_retry -I INPUT -p tcp --dport 2051 -j ACCEPT
  
  # Setup redirection enabled mark
  touch ${MARK_TRAFFIC}
  
  # Update loss counter
  update_loss_counter
}

stop_traffic_redirection()
{
  logger "nodewatcher: Stopping traffic redirection"
  # Remove iptables redirection rule
  generate_rules "D"
  iptables_retry -t nat -F CLIENT_REDIRECT
  iptables_retry -t nat -X CLIENT_REDIRECT
  iptables_retry -D INPUT -p tcp --dport 2051 -j ACCEPT
  
  # Remove redirection enabled mark
  rm -f ${MARK_TRAFFIC}
}

start_dnsmasq()
{
  # Start dnsmasq and ensure that it has started
  for _ in $(seq 1 5); do
    /usr/sbin/dnsmasq $*
    
    if [[ "$?" == "0" ]]; then
      break
    else
      # Unable to start, sleep a second and retry
      sleep 1
    fi
  done
}

try_dns_redirection()
{
  WHICH="$1"
  
  # We only start redirection when both conditions are true
  if [[ "${WHICH}" == "traffic" ]]; then
    MARK="${MARK_DNS_DOWN}"
  elif [[ "${WHICH}" == "dns" ]]; then 
    MARK="${MARK_TRAFFIC}"
    
    # Setup DNS down flag
    touch ${MARK_DNS_DOWN}
  fi
  
  if [[ -f ${MARK} ]]; then
    start_dns_redirection
  fi
}

unmark_dns_down()
{
  rm -f ${MARK_DNS_DOWN}
}

kill_gracefully()
{
  killall -q $1
  sleep 1
  killall -q -9 $1
}

start_dns_redirection()
{
  logger "nodewatcher: Starting dns redirection"
  # Setup redirection enabled mark
  touch ${MARK_DNS}
  
  # Put dnsmasq into redirection mode
  get_local_ip
  kill_gracefully dnsmasq
  start_dnsmasq --address=/#/${LOCAL_IP} --local-ttl=1
}

stop_dns_redirection()
{
  logger "nodewatcher: Stopping dns redirection"
  # Put dnsmasq into normal mode
  kill_gracefully dnsmasq
  start_dnsmasq
  
  # Remove redirection enabled mark
  rm -f ${MARK_DNS}
}

update_loss_counter()
{
  COUNTER=`cat ${LOSS_COUNTER} 2>/dev/null`
  let COUNTER++
  echo ${COUNTER} > ${LOSS_COUNTER}
}
