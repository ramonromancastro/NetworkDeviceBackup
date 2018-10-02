# http://unix.stackexchange.com/questions/14684/removing-control-chars-including-console-codes-colours-from-script-output
while (my $var = <>) {
	# CONTROL CHARACTERS
    $var =~ s/ \e[ #%()*+\-.\/]. |
	\r | # Remove extra carriage returns also
    (?:\e\[|\x9b) [ -?]* [@-~] | # CSI ... Cmd
    (?:\e\]|\x9d) .*? (?:\e\\|[\a\x9c]) | # OSC ... (ST|BEL)
    (?:\e[P^_]|[\x90\x9e\x9f]) .*? (?:\e\\|\x9c) | # (DCS|PM|APC) ... ST
	\e.|[\x80-\x9f] //xg;
	#$var =~ s/[^\b][\b]//g;
	# HH3C, ProCurve
	$var =~	s/-- MORE --, next page: Space, next line: Enter, quit: Control-C//;
	# FORTIGATE
	$var =~	s/--More--//;
	# DGS
	$var =~	s/CTRL+C ESC q Quit SPACE n Next Page ENTER Next Entry a All//;
    print $var;
}