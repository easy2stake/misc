#!/bin/bash

PRUNE_HEIGHT=$1
DATA_DIR=/home/pocket/.pocket/data/

# Functions section

# EX: prune_now $PRUNE_HEIGHT
prune_now(){
  systemctl stop cron
  systemctl stop pocket
  cd $DATA_DIR

  wget --quiet https://github.com/easy2stake/misc/raw/main/pocket/prune
  chmod 700 prune
  chown pocket prune
  sudo -u pocket ./prune $1 .
  rm -rf blockstore.db
  mv blockstore-new.db blockstore.db

  systemctl start pocket
  systemctl start cron
  systemctl status --no-pager pocket
  df -h
}

# Main section
disk_used=$(df -h / | grep /$ | xargs | cut -d" " -f 5 | tr -d '%')
if (( $disk_used > 85 ))
then
    if [[ `tail -n 30 /var/log/nginx/access.log | grep -q -i axios; echo $?` -eq 1 ]]; then
      >&2 echo -e "`hostname` -> No relays detected.\nDisk used: $disk_used.\nWe'll continue pruning."
      prune_now $PRUNE_HEIGHT
    else
      >&2 echo "`hostname` -> Pocket relays detected on node: `hostname`"
    fi
else
  >&2 echo -e "`hostname` -> Disk used: $disk_used/\nPruning not needed."
fi
