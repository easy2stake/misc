#!/bin/bash

# General vars
POCKET_USER=pocket
POCKET_WORKDIR=/home/${POCKET_USER}/.pocket

# restore_db_from_archive vars
DATA_SERVER=https://storage.googleapis.com/blockchains-data
DATA_FILE=27Kbackup.tar
DOWNLOAD_LOCATION=/tmp

# download_binary vars
BINARY_LOCAL=/home/${POCKET_USER}/go/bin	#Insert your pocket binary location here
BINARY_RELEASE=https://raw.githubusercontent.com/easy2stake/misc/main/pocket/bin/pocket-RC-0.6.3 #This is a 0.6.3 release compiled on Ubuntu 18.04

function delete_data_folders(){
  rm -rf ${POCKET_WORKDIR}/data
  rm -rf ${POCKET_WORKDIR}/session.db
  rm -rf ${POCKET_WORKDIR}/pocket_evidence.db
}
function restore_db_from_archive(){
  rm ${DOWNLOAD_LOCATION}/${DATA_FILE}
  wget ${DATA_SERVER}/${DATA_FILE} -P ${DOWNLOAD_LOCATION}
  tar -xzvf ${DOWNLOAD_LOCATION}/${DATA_FILE} -C ${POCKET_WORKDIR}
  chown -R ${POCKET_USER}:${POCKET_USER} ${POCKET_WORKDIR}
  rm ${DOWNLOAD_LOCATION}/${DATA_FILE}
}
function download_binary(){
	mv ${BINARY_LOCAL}/pocket ${BINARY_LOCAL}/pocket.old
	wget ${BINARY_RELEASE} -P ${BINARY_LOCAL}  -O pocket
	chown -R ${POCKET_USER}:${POCKET_USER} ${BINARY_LOCAL}
	chmod 700 ${BINARY_LOCAL}/pocket
}

systemctl stop -s KILL pocket
delete_data_folders
download_binary
restore_db_from_archive
systemctl start pocket
