#!/bin/bash
host_prefix=e2sfc4-pocket-
domain=easy2stake.com
paralelism=35
ip_list=all-servers.txt

# Function definition
function run_by_domain(){
  count=0
  for i in $(seq 0 93)
  do
      (( count=$count+1 ))

      echo "Running prune on ${host_prefix}${i}.${domain}"
      ssh -o "StrictHostKeyChecking=no" -i .ssh/id_rsa_hcloud_pocket root@${host_prefix}${i}.${domain} "curl -s https://raw.githubusercontent.com/easy2stake/misc/main/pocket/scripts/prune.sh > prune.sh && bash prune.sh 43500 > /tmp/prune.log" &

      if [[ $count -eq $paralelism ]]; then
          count=0
          wait
      fi
  done
}

function run_by_ip(){
  count=0
  for i in $(cat $ip_list)
  do
    (( count=$count+1 ))
    echo "Running prune on $ip"
    ssh -o "StrictHostKeyChecking=no" -i .ssh/id_rsa_hcloud_pocket root@$ip "curl -s https://raw.githubusercontent.com/easy2stake/misc/main/pocket/scripts/prune.sh > prune.sh && bash prune.sh 43500 > /tmp/prune.log" &

    if [[ $count -eq $paralelism ]]; then
        count=0
        wait
    fi
  done
}

## Main section
run_by_ip
