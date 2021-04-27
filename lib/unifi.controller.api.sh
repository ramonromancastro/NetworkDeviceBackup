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

username=$PluginUsername
password=$PluginPassword
baseurl=https://$PluginDevice:8443
site=default

#
# Loading unifi_sh_api
#

[ -f $(dirname `readlink -f -- $0`)/unifi_sh_api ] && . $(dirname `readlink -f -- $0`)/unifi_sh_api || {
  echo "unifi_sh_api missing!";
  echo "Download specific unifi_sh_api (shell library) version from https://community.ui.com/releases/."
  exit 1;
}

#
# Log in UniFi Controller
#

result=$(unifi_login)
[[ ! $result =~ '"rc":"ok"' ]] && { echo "Unable to login!"; exit 1; }

#
# Run and download backup
#

unifi_backup "${rrcndbBackupDir}/${PluginDevice}.${rrcndbConfExt}"

#
# Log out UniFi Controller
#

unifi_logout
