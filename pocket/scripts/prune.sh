PRUNE_HEIGHT=$1
DATA_DIR=/home/pocket/.pocket/data/

systemctl stop pocket
cd $DATA_DIR

wget https://github.com/easy2stake/misc/raw/main/pocket/prune
chmod 700 prune
chown pocket prune
sudo -u pocket ./prune $PRUNE_HEIGHT .
rm -rf blockstore.db
mv blockstore-new.db blockstore.db

systemctl start pocket
systemctl status --no-pager pocket
df -h
