#!/bin/bash
# Written by thelinuxgirl
# https://github.com/thelinuxgirl/iterm-auto-ssh/
# Auto-ssh - auto ssh to defined hosts based on iterm session ID's #
# Mac Iterm2 users
# Set the Hostname values to the ITERM_SESSION_ID for
# the window/tab/pane you want to define and the
# value is the name of the host to ssh to

# SSH reconnect for iterm2
# connects to a specified set of hosts for a
# specified list of tabs and reconnects to a specific
# screen for that window/tab/pane

# Debugging var, for debug output
#$_debugging=1

##################### DEPENDENCIES: #######################################
# - Must use/src bssh function snippet from bashrc.snippet.               #
#   	-Add the contents of bashrc.snippet to the bottom of your .bashrc #
# - Must setup auto-ssh.conf, sourced in for key-value host/id pairs      #
# 	-Define config variable's path to config (below)
###########################################################################


autossh_init(){
## config file with host-id key pairs ##
config=~/iterm-auto-ssh/auto-ssh.conf

## source in our bashrc so our bssh function works when this is run in standalone ##
if [[ -f ~/.bashrc ]]; then
	. ~/.bashrc
else
	echo "Couldn't source .bashrc, aborting"
	return 1
fi

if [[ -f $config ]]; then
	. ${config}
else
	echo "can't find config file at $config"
	return 1
fi
}


ssh_connect() {
 host_set=false

 id=$ITERM_SESSION_ID
 wtpid=${id}
 wtid=${id%%p[0-9]}
 wid=${id%%t[0-9]p[0-9]}

 [[ $_debugging ]] && echo "id: $id  wtpid: $wtpid  wtid: $wtid  wid: $wid "


 ### Session ID check ###
 ### Iterate over session array, and check session id's ###

 [[ $_debugging ]] && echo "session arr ${session_arr[*]} "

 for session in ${session_arr[*]}; 
 do
	## Pull hostnames for sessions in array ##
	[[ $_debugging ]] && echo "session array: $session"

	## indirectly reference session variable, to pull out session id list ##
	session_ids=( ${!session} )
	[[ $_debugging ]] && echo "session array ids: ${session_ids[*]} "

	## iterate over session id's for defined host/session, and check against current session ID ##
	for session_id in ${session_ids[*]};
	do
	[[ $_debugging ]] && echo "session id: $session_id"
		if echo $wtpid | grep $session_id || {
			echo $wtid | grep $session_id
			} || { 
			echo $wid | grep $session_id
			}; 
		then
			ssh_host=$session
			host_set=true
		else
			host_set=false
		fi
	done
	if ${host_set} ; then
		[[ $_debugging ]] && echo "Set session to ${ssh_host} with id ${id} - spawning ssh connect"
		break
	else
		echo "host $session doesn't match this iterm session ID"
	fi
done

## No match found - abort ##
if [[ -z ${ssh_host} ]]; then
	[[ $_debugging ]] && echo "error: no host assigned to these sessions: $wtpid , $wtid , $wid , aborting auto-ssh" 
	return 1
else
 	[[ $_debugging ]] && echo "final ssh host set: $ssh_host"
fi

 [[ $_debugging ]] && echo "id: $id wtpid: $wtpid wtid: $wtid wid: $wid "

### ssh connect stanza ###
	if [[ -n $ssh_host ]] ; then
		bssh ${ssh_host} ${id}
	else
		echo "No host defined for $id"
	fi
}

autossh_init
ssh_connect
