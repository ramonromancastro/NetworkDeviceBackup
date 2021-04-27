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

hpeStatus=0
hpeCookie=${rrcndbTmpDir}/${PluginDevice}.cookie

rm -rf ${hpeCookie} > /dev/null 2>&1

# Login
curl --connect-timeout ${timeout} -c ${hpeCookie} --insecure --request POST --data "username=${PluginUsername}&password=${PluginPassword}" "https://$PluginDevice/htdocs/login/login.lua" > /dev/null 2>&1
if [ $? -ne 0 ]; then exit 1; fi
# Preparing backup
curl --connect-timeout ${timeout} -b ${hpeCookie} --insecure --request POST --data "file_type_sel=config" "https://$PluginDevice/htdocs/lua/ajax/file_upload_ajax.lua?protocol=6" > /dev/null 2>&1
if [ $? -eq 0 ]; then
        # Downloading backup
        curl --connect-timeout ${timeout} -b ${hpeCookie} --insecure --request GET "https://${PluginDevice}/htdocs/pages/base/file_http_download.lsp?name=startup-config&file=/mnt/download/startup-config"
        if [ $? -ne 0 ]; then hpeStatus=1; fi
        # Liberating backup
        curl --connect-timeout ${timeout} -b ${hpeCookie} --insecure --request GET "https://${PluginDevice}/htdocs/pages/base/file_http_download.lsp?name=startup-config&file=/mnt/download/startup-config&remove=true" > /dev/null 2>&1
        if [ $? -ne 0 ]; then hpeStatus=1; fi
else
        hpeStatus=1
fi
# Logout
curl --connect-timeout ${timeout} -b ${hpeCookie} --insecure --request GET "https://${PluginDevice}/htdocs/pages/main/logout.lsp" > /dev/null 2>&1
if [ $? -ne 0 ]; then hpeStatus=1; fi

rm -rf ${hpeCookie} > /dev/null 2>&1

exit ${hpeStatus}
