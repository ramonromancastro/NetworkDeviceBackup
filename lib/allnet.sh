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
# SCRIPT VARIABLES
#

HtmlCookie="${rrcndbTmpDir}/allnet.${PluginDevice}"

#
# DONWLOAD CONFIG FILE
#

wget -q -O /dev/null --save-cookies "${HtmlCookie}" --keep-session-cookies --post-data 'username=${PluginUsername}&pwd=${PluginPassword}' "http://${PluginDevice}/usr/usrgetform.html?name=index"
if [ $? -ne 0 ]; then
	rm -f "${HtmlCookie}"
	exit 1000
fi

wget -q -O "${rrcndbBackupDir}/${PluginDevice}.${rrcndbConfExt}" --load-cookies "${HtmlCookie}" "http://${PluginDevice}/adm/getconfbin.html"
if [ $? -ne 0 ]; then
	wget -q -O /dev/null --load-cookies "${HtmlCookie}" "http://${PluginDevice}/adm/logout.html"
	rm -f "${HtmlCookie}"
	exit 1001
fi

wget -q -O /dev/null --load-cookies "${HtmlCookie}" "http://${PluginDevice}/adm/logout.html"
rm -f "${HtmlCookie}"