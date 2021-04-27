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

#
# FUNCTIONS
#

function clearCookies(){
	rm -f $PluginDevice.cookie
}

function logout(){
	curl --silent --insecure $BaseUrl/logout
	clearCookies
}

#
# SCRIPT VARIABLES
#

BaseUrl=https://$PluginDevice:8443


###############################
# CODE
###############################


# Login

loginResult=$(curl --silent --insecure --cookie-jar $PluginDevice.cookie --cookie $PluginDevice.cookie --referer $BaseUrl/login --data "{\"username\":\"$PluginUsername\",\"password\":\"$PluginPassword\"}" $BaseUrl/api/login)
if [[ ! $loginResult =~ \{\"rc\":\"ok\"\} ]]; then
	clearCookies
	exit 1000
fi

# Get last backup
lastBackup=$(curl --silent --insecure --cookie-jar $PluginDevice.cookie --cookie $PluginDevice.cookie --data "{\"cmd\":\"list-backups\"}" $BaseUrl/api/s/default/cmd/backup | jq '.data | sort_by(.time) | reverse | .[0].filename' -r)
if [ $? -ne 0 ] || [ -z "lastBackup" ]; then
	logout
	exit 1000
fi

curl --silent --insecure --cookie-jar $PluginDevice.cookie --cookie $PluginDevice.cookie $BaseUrl/dl/autobackup/$lastBackup > ${rrcndbBackupDir}/${PluginDevice}.${rrcndbConfExt}
logout
