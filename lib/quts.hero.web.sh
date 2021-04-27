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

# API for QNAP QTS Authentication
# https://download.qnap.com/dev/API_QNAP_QTS_Authentication.pdf
# http://eu1.qnap.com/Storage/SDK/get_sid.js

qutsStatus=0
QNAP_SID=

# Login
QNAP_SID=$(curl --connect-timeout ${timeout} --insecure --request POST --data "user=${PluginUsername}&pwd=${PluginPassword}&service=1" https://${PluginDevice}/cgi-bin/authLogin.cgi 2> /dev/null | tr -d "\r\n" | grep "authSid" | sed -e 's/.*<authSid><!\[CDATA\[\(.*\)\]\]><\/authSid>.*/\1/')
if [ ! -z "${QNAP_SID}" ]; then
	# Backup
	curl --insecure --location --request GET "https://${PluginDevice}/cgi-bin/sys/sysRequest.cgi?sid=${QNAP_SID}&subfunc=conf_backup&backup_config=1&br_type=127" --output "${rrcndbBackupDir}/${PluginDevice}.${rrcndbConfExt}" 2> /dev/null
	if [ $? -ne 0 ]; then qutsStatus=1; fi

	# Logout
	curl --insecure --request POST --data "logout=1" "https://${PluginDevice}/cgi-bin/authLogout.cgi?sid=${QNAP_SID}" > /dev/null 2>&1
	if [ $? -ne 0 ]; then qutsStatus=1; fi
	
	curl --insecure --request POST "https://${PluginDevice}/cgi-bin/qsync/qsyncsrv_logout.cgi" > /dev/null 2>&1
	if [ $? -ne 0 ]; then qutsStatus=1; fi
else
	qutsStatus=1
fi

exit ${qutsStatus}
