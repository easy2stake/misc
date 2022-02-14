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
      >&2 echo -e "`hostname` -> \t| Code:0 \t| No relays detected\t| Disk used: $disk_used.\t| We'll continue pruning."
      prune_now $PRUNE_HEIGHT
    else
      >&2 echo -e "`hostname` -> \t| Code:1 \t| Pocket relays detected on node: `hostname`\t| Cannot prune. Try again later."
    fi
else
  >&2 echo -e "`hostname` -> \t| Code:10 \t| Disk used: $disk_used\t| Pruning not needed."
fi
