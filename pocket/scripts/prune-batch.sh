#!/bin/bash

count=0
for i in $(seq 3 10)
do
    (( count=$count+1 ))
    
  
    echo "Running prune on e2s-pocket-${i}.easy2stake.com"
    ssh -o "StrictHostKeyChecking=no" -A root@e2s-pocket-${i}.easy2stake.com "curl -s https://raw.githubusercontent.com/easy2stake/misc/main/pocket/scripts/prune.sh > prune.sh && bash prune.sh 43500 > /tmp/prune.sh" &
    
    if [[ $count -eq 4 ]]; then
        count=0
        wait
    fi
done
