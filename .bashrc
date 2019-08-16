# .bashrc


# Source global definitions
if [ -f /etc/bashrc ]; then
		. /etc/bashrc
	fi

	export PATH=$PATH:~/.local/bin
	export HISTCONTROL=ignoredups


	[ -z "$PS1" ] && return

	#START
	#
	# Define the colors
	#
	black='\e[0;30m'
	blue='\e[0;34m'
	green='\e[0;32m'
	cyan='\e[0;36m'
	red='\e[0;31m'
	purple='\e[0;35m'
	brown='\e[0;33m'
	lightgray='\e[0;37m'
	darkgray='\e[1;30m'
	lightblue='\e[1;34m'
	lightgreen='\e[1;32m'
	lightcyan='\e[1;36m'
	lightred='\e[1;31m'
	lightpurple='\e[1;35m'
	yellow='\e[1;33m'
	white='\e[1;37m'
	nc='\e[0m'
	#
	# Get ifconfig information
	#
	netinfo ()
	{
		echo "-------------------------- Network Information --------------------------"
		/sbin/ifconfig | awk /'inet addr/ {print $2}'
		/sbin/ifconfig | awk /'Bcast/ {print $3}'
		/sbin/ifconfig | awk /'inet addr/ {print $4}'
		/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	}
	#
	# Define a few functions
	#
	# Get the mounted drives and free space
	#
	mounted ()
	{
		echo "---------------------------- Mounted Drives -----------------------------"
		df -h
	}
	#
	# Check free memory
	#
	meminfo ()
	{
		echo "-------------------------- Memory Information ---------------------------"
		free -tm
	}
	#
	# Look at uptime
	#
	upinfo ()
	{
		echo "------------------------------- Uptime ----------------------------------"
		echo ""
		echo -ne "${lightblue}Uptime for:${green} $HOSTNAME ${lightblue}is ${cyan}";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}' 
	}
	#
	# Show the Welcome Screen
	#
	clear
	echo -e "${red}+++++++++++++++++++++++++++++${white} W E L C O M E ${red}++++++++++++++++++++++++++++${nc}"; 
	echo ""
	echo -e "${lightblue}Host: \t\t\t ${cyan}$HOSTNAME"
	echo -ne "${lightblue}Operating System: \t${cyan}" `cat /etc/*-release`; 
	echo ""
	echo -e "${lightblue}Kernel Information: \t${cyan}" `uname -smr`
	echo -ne "${lightblue}Hello ${lightred}$USER ${lightblue}today is: \t${cyan}" `date`; 
	echo ""; 
	echo "";
	echo -ne "${cyan}";netinfo; echo ""
	echo -ne "${green}";mounted; echo ""
	echo -ne "${red}";meminfo; echo ""
	echo -ne "${cyan}";upinfo; echo ""
	echo -ne "${nc}"
	echo ""
	#STOP


	# User specific aliases and functions
	reloadBash(){
		  source ~/.bashrc
	  }
	  alias rb=reloadBash
	  alias rm='rm -i'
	  # This is GOLD for finding out what is taking so much space on your drives!
	  alias diskspace="du -Sh | sort -n -r |more"
	  # Show me the size (sorted) of only the folders in this directory
	  alias folders="find . -maxdepth 1 -type d -print | xargs du -skh | sort -rn"
	  alias ll="ls -alh --color"
      alias dir="ll"
	  alias df="df -h"
	  export PS1='[`date +%T` \u@\h \W]\$ '

	  # User specific aliases and functions
	  alias checkConn="netstat -anp | grep tcp | awk '{print $5}' | cut -f 1 -d : | sort | uniq -c | sort -n"
	  alias checkConn2="lsof -nPi tcp -F n | awk -F\> '/>/{print$2}'| sort | uniq -c | sort -nr"

	  alias mkdir='mkdir -pv'

	  # Stop after sending count ECHO_REQUEST packets #
	  alias ping='ping -c 5'
	  # Do not wait interval 1 second, go fast #
	  alias fastping='ping -c 100 -s.2'

	  # get web server headers #
	  alias header='curl -I'
	   
	  # find out if remote server supports gzip / mod_deflate or not #
	  alias headerc='curl -I --compress'


	  ## pass options to free ##
	  alias meminfo='free -m -l -t'
	   
	  ## get top process eating memory
	  alias psmem='ps auxf | sort -nr -k 4'
	  alias psmem10='ps auxf | sort -nr -k 4 | head -10'
	   
	  ## get top process eating cpu ##
	  alias pscpu='ps auxf | sort -nr -k 3'
	  alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
	   
	  ## Get server cpu info ##
	  alias cpuinfo='lscpu'

	  ## this one saved by butt so many times ##
	  alias wget='wget -c'

	  alias df='df -H'
	  alias du='du -ch'
	  alias ls='ls -alh --color'
      alias update="sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade"
export wORK_DIR=~/ansible/
