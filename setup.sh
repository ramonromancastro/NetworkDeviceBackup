#!/bin/bash

# CONSTANTES

script_name="setup.sh"
version=1.2

RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

read -rd '' logo_ascii <<'EOF'

\e[31m\e[1m               \e[0m\e[1m__\e[31m\e[1m__ \e[0m\e[1m            __ _\e[0m
\e[31m\e[1m _ __ _ __ ___\e[0m\e[1m|__\e[31m\e[1m_ \\\e[0m\e[1m ___  ___  / _| |___      ____ _ _ __ ___\e[0m
\e[31m\e[1m| '__| '__/ __|\e[0m\e[1m _\e[31m\e[1m_) \e[0m\e[1m/ __|/ _ \| |_| __\ \ /\ / / _` | '__/ _ \\\e[0m
\e[31m\e[1m| |  | | | (__ \e[0m\e[1m/ \e[31m\e[1m__/\e[0m\e[1m\__ \ (_) |  _| |_ \ V  V / (_| | | |  __/\e[0m
\e[31m\e[1m|_|  |_|  \___|\e[0m\e[1m__\e[31m\e[1m___\e[0m\e[1m|___/\___/|_|  \__| \_/\_/ \__,_|_|  \___|\e[0m

\e[31m\e[1mrrc2software\e[0m @ \e[1mNetworkDeviceBackup\e[0m
\e[1mCopias de seguridad de dispositivos de red\e[0m


EOF

# VARIABLES

DESTDIR=$(dirname "$(readlink -f "$0")")
action=

# FUNCTIONS

success(){
	$MOVE_TO_COL
	echo -n "["
	$SETCOLOR_SUCCESS
	echo -n $"  OK  "
	$SETCOLOR_NORMAL
	echo -n "]"
	echo -ne "\r"
	return 0
}

failure(){
	$MOVE_TO_COL
	echo -n "["
	$SETCOLOR_FAILURE
	echo -n $"FAILED"
	$SETCOLOR_NORMAL
	echo -n "]"
	echo -ne "\r"
	return 1
}

log_action(){
    local STRING rc

    STRING=$1
    echo -n "$STRING "
    shift
    "$@" >> setup.log 2>&1 && success $"$STRING" || failure $"$STRING"
    rc=$?
    echo
    return $rc
}

read_parameters(){
	while [[ $# -gt 0 ]]; do
		key="$1"
		case $key in
			-p|--path)
				DESTDIR="$2"
				shift
				;;
			-a|--action)
				action="$2"
				shift
				;;
			-V|--version)
				version
				exit 1
				;;
			-h|--help)
				help
				exit 1
				;;
			*)
				shortusage
				exit 1
				;;
		esac
		shift
	done
}

msg(){
	echo "$1"
}

error_msg(){
	echo "$1"
	exit 1
}

check_parameters(){
	[ -z "$DESTDIR" ] && error_msg "Installation path not defined!"
	[ ! -d "$DESTDIR" ] && error_msg "Installation path not exists!"
}

logo(){
	printf '%b' "$logo_ascii\n\n"
}

summary(){
	cat << EOF

------------------------------------------------------------
Installation dir : $DESTDIR
Application bin  : $DESTDIR/bin/rrcndb.sh
WebUI access     : http://$(hostname)/rrcndb
WebUI username   : admin
WebUI password   : rrcndb
------------------------------------------------------------
EOF
}

do_action(){
	case "$action" in
		"prerequisites")
			logo
			prerequisites
		;;
		"install")
			logo
			install
			summary
		;;
		*)
			help
		;;
	esac
}

prerequisites(){
	log_action "Install application prerequisites" yum -y install coreutils expect httpd perl php sed sendmail wget net-snmp-utils
}

install_parse(){
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/bin/rrcndb.sh.in > ${DESTDIR}/bin/rrcndb.sh
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/etc/rrcndb.conf.in > ${DESTDIR}/etc/rrcndb.conf
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/etc/config.in > ${DESTDIR}/etc/config
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/etc/config.exp.in > ${DESTDIR}/etc/config.exp
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/extra/rrcndb.cron.in > ${DESTDIR}/extra/rrcndb.cron
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/extra/rrcndb.httpd.in > ${DESTDIR}/extra/rrcndb.httpd
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/extra/rrcndb.logrotate.in > ${DESTDIR}/extra/rrcndb.logrotate
	sed "s,@DESTDIR@,${DESTDIR},g" ${DESTDIR}/share/config.template.php > ${DESTDIR}/share/config.php
}

install_dirs(){
	find ${DESTDIR} -type d -exec chmod 755 {} \;
	find ${DESTDIR} -type f -exec chmod 644 {} \;
}

install_app_files(){
	find ${DESTDIR}/bin -type f -exec chmod 755 {} \;
	find ${DESTDIR}/etc -type f -exec chmod 600 {} \;
	find ${DESTDIR}/includes -type f -exec chmod 640 {} \;
	find ${DESTDIR}/lib -type f -name "*.sh" -o -name "*.exp" -exec chmod 750 {} \;
	
	ln -s ${DESTDIR}/extra/rrcndb.logrotate /etc/logrotate.d/rrcndb
	ln -s ${DESTDIR}/extra/rrcndb.cron /etc/cron.d/rrcndb
}

install_webui_files(){
	chown root:apache ${DESTDIR}/share -R
	chcon -R -t httpd_sys_content_t ${DESTDIR}/share
	ln -s ${DESTDIR}/extra/rrcndb.httpd /etc/httpd/conf.d/rrcndb.conf
}

install_remove_temporal(){
	find ${DESTDIR} -type f -name "*.in" -exec rm -f {} \;
}

install(){
	log_action "Customize installation files" install_parse
	log_action "Create installation directories" install_dirs
	log_action "Install base application" install_app_files
	log_action "Install WebUI" install_webui_files
	log_action "Remove temporary files" install_remove_temporal
}

version(){
	echo "$script_name $version";
}

help(){
	cat << EOF

   $script_name [OPTIONS] - Install an application

   This script install an application

   OPTIONS:
      -p|--path      Installation path
                     Default value: ${DESTDIR}
      -a|--action    Execute an action. Actions availables are:
                        - install         Install the application.
                        - prerequisites   Install prerequisites.
      -h|--help      This help text
      -V|--version   Print version number

EOF
	exit 1
}

shortusage(){
	cat << EOF
Usage: $script_name [OPTIONS]
$script_name -h for more information.
EOF
}

# MAIN CODE
[ -f setup.log ] && rm -f setup.log
read_parameters "$@"
check_parameters
do_action

echo -e "\nExecution complete!\nCheck setup.log for errors.\n"