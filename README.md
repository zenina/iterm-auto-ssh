iterm-auto-ssh
==============

Iterm Auto SSH script, with .bashrc integration. Forces ssh to hosts based on iterm window/tab/pane

Includes:
- iterm-auto-ssh.sh : iterm-auto-ssh script, can be run standalone (with .bashrc snippet), or enabled on login/session.
- auto-ssh.conf : key-value pairs for hosts and window/tab/pane ID assignments, and 'active' array (see comments in config)
- bashrc.snippet  : bashrc settings for bssh function, used by auto-ssh script, and auto-ssh on login/new session. 
    - bssh (function) : ssh funciton loops over hostname until connecting, and creates screen with name given. 
     This can be used standalone on the commandline, or within other scripts.
     Syntax:
        bssh <host> [screen]
    - Note: uncomment the iterm-auto-ssh section at the bottom to enable on login. 

Installation:
- Place directory in homedir, or desired location. 
- Add directory to your PATH variable in .bashrc/.bash_profile if you don't want to have to reference the script directly.
- Modify/Update your config file with hosts, and window/tab/pane id's (see comments in config file)
- Source bashrc.snippet from your .bashrc or .bash_profile to load in all the bssh function data.
    - add the source line to the bottom of your .bashrc/.bash_profile
      . ~/iterm-auto-ssh/bashrc.snippet
      (uncomment the bottom section of this snippet if you want auto-ssh to run on login)
      NOTE: If you uncomment this/set for login, it will only run within iterm, as it does a terminal app variable check
- Verify $config variable path in iterm-auto-ssh.sh (Default: ~/iterm-auto-ssh/auto-ssh.conf )
    - if you're using another location, modify this variables path to reflect such. 


Log out of your sessions, and back in.

Running:
- Run manually from command line:
      ~/iterm-auto-ssh/iterm-auto-ssh.sh
- Running bssh ssh wrapper function from command line:
      bssh <host> <screen title>


Auto-ssh run on login, or Iterm session start:
  Auto-ssh is disabled by default in the bashrc snippet.
  Uncomment the following lines from your bashrc.snippet to force auto-ssh to run on session start/login:
  
  
bashrc.snippet (if enabled/uncommented, this is how it should appear)

    ##### Iterm Auto SSH on Login #####
    # Uncomment to run auto-ssh on login #

    if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
        . ~/iterm-auto-ssh.sh
    fi


