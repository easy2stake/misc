#!/bin/bash

###
# ATTENTION: This script will remove your current data folder and replace it with a 0.6.3 compatible one starting at 27k.
#            It will not touch your keys!
#            It will only delete the data, session.db and pocket_evidence.db.
#            Your validator will use the priv_val_state.json so it will know it's final state.
##


# General vars
POCKET_USER=pocket 				#The linux user where your pocket node is installed. If you used root, simply change the name here with "root".
POCKET_WORKDIR=/home/${POCKET_USER}/.pocket 	#This is your .pocket folder location. Example: /home/pocket/.pocket

# restore_db_from_archive vars
DATA_SERVER=https://storage.googleapis.com/blockchains-data 	#Do not change this part if you want to download the official archive posted by pocket team
DATA_FILE=27Kbackup.tar					 	#Do not change this part if you want to download the official archive posted by pocket team
DOWNLOAD_LOCATION=/tmp

# download_binary vars
BINARY_LOCAL=/home/${POCKET_USER}/go/bin	#Insert your pocket binary location here. Ex: /home/pocket/bin/ OR /home/pocket/go/bin, etc
BINARY_RELEASE=https://raw.githubusercontent.com/easy2stake/misc/main/pocket/bin/pocket-RC-0.6.3 #This is a 0.6.3 release compiled on Ubuntu 18.04

function delete_data_folders(){
  rm -rf ${POCKET_WORKDIR}/data
  rm -rf ${POCKET_WORKDIR}/session.db
  rm -rf ${POCKET_WORKDIR}/pocket_evidence.db
}
function restore_db_from_archive(){
  rm ${DOWNLOAD_LOCATION}/${DATA_FILE}
  wget ${DATA_SERVER}/${DATA_FILE} -P ${DOWNLOAD_LOCATION}
  tar -xvf ${DOWNLOAD_LOCATION}/${DATA_FILE} -C ${POCKET_WORKDIR}
  
  # Small fix to work with pocket archive
  mv ${POCKET_WORKDIR}/node1/* ${POCKET_WORKDIR}/
  
  chown -R ${POCKET_USER}:${POCKET_USER} ${POCKET_WORKDIR}
  rm ${DOWNLOAD_LOCATION}/${DATA_FILE}
}
function download_binary(){
	mv ${BINARY_LOCAL}/pocket ${BINARY_LOCAL}/pocket.old
	wget ${BINARY_RELEASE} -P ${BINARY_LOCAL}  -O pocket
	chown -R ${POCKET_USER}:${POCKET_USER} ${BINARY_LOCAL}
	chmod 700 ${BINARY_LOCAL}/pocket
}

systemctl stop -s KILL pocket 	#Replace "pocket" if you are using a diferent process name
delete_data_folders
download_binary
restore_db_from_archive
systemctl start pocket		#Replace "pocket" if you are using a diferent process name
