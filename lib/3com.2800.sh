#!/bin/bash

####################################################################
# DO NOT MODIFY!! ALWAYS INCLUDE THIS CODE INSIDE SHELL PLUGINS
####################################################################

. $(dirname `readlink -f -- $0`)/../etc/config.sh
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

HtmlCookie="${rrcndbTmpDir}/3Com.2800.${PluginDevice}"

#
# DONWLOAD CONFIG FILE
#

wget -q -O /dev/null --save-cookies "${HtmlCookie}" --keep-session-cookies --post-data="Username=${PluginUsername}&Password=${PluginPassword}" "http://${PluginDevice}/cgi/login.cgi"
if [ $? -ne 0 ]; then
	rm -f "${HtmlCookie}"
	exit 1000;
fi

wget -q -O "${rrcndbBackupDir}/${PluginDevice}.${rrcndbConfExt}" --load-cookies "${HtmlCookie}" "http://${PluginDevice}/wbackup.dat"
if [ $? -ne 0 ]; then
	wget -q -O /dev/null --load-cookies "${HtmlCookie}" "http://${PluginDevice}/cgi/logout.cgi"
	rm -f "${HtmlCookie}"
	exit 1001;
fi

wget -q -O /dev/null --load-cookies "${HtmlCookie}" "http://${PluginDevice}/cgi/logout.cgi"
rm -f "${HtmlCookie}"
