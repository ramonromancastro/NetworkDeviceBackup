#!/bin/bash

####################################################################
# DO NOT MODIFY!! ALWAYS INCLUDE THIS CODE INSIDE SHELL PLUGINS
####################################################################

. $(dirname `readlink -f -- $0`)/../etc/config
. $(dirname `readlink -f -- $0`)/includes/functions
. $(dirname `readlink -f -- $0`)/../etc/rrcndb.conf

PluginDevice=$1
PluginUsername=$(find_login "${PluginDevice}" "user")
PluginPassword=$(find_login "${PluginDevice}" "password")

####################################################################
# ADD YOUR CODE HERE
####################################################################

netappMountDir=${rrcndbTmpDir}/netappMnt
netappVolumeName=/vol/vol0
netappConfigFile=etc/configs/config_dump

# GENERATE CONFIG BACKUP FILE
${rrcndbLibDir}/netapp.exp ${PluginDevice}
if [ $? -ne 0 ]; then exit 5; fi

# MOUNT NFS TO NETAPP VOLUME
mkdir -p ${netappMountDir} > /dev/null 2>&1
if [ $? -ne 0 ]; then exit 6; fi
mount -o nolock ${PluginDevice}:${netappVolumeName} ${netappMountDir} > /dev/null 2>&1
if [ $? -ne 0 ]; then exit 7; fi

# COPY CONFIG BACKUP TO BACKUP FOLDER
cp -f "${netappMountDir}/${netappConfigFile}" "${rrcndbTmpDir}/${PluginDevice}.${rrcndbRawExt}" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	umount ${netappMountDir} > /dev/null 2>&1
	exit 8
fi

# UMOUNT NFS TO NETAPP VOLUME
umount ${netappMountDir} > /dev/null 2>&1
if [ $? -ne 0 ]; then exit 9; fi
