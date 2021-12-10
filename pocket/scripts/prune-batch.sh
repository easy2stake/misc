#!/bin/bash
host_prefix=e2sfc4-pocket-
domain=easy2stake.com
paralelism=35

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
