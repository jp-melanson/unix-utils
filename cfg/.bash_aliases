#!/bin/sh

# thanks to:  http://blog.blindgaenger.net/colorize_maven_output.html
# and: http://johannes.jakeapp.com/blog/category/fun-with-linux/200901/maven-colorized
# Colorize Maven Output
# alias maven="command mvn"
# color_maven() {
#  maven $* | sed -e 's/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/[1;32mTests run: \1[0m, Failures: [1;31m\2[0m, Errors: [1;33m\3[0m, Skipped: [1;34m\4[0m/g' \
#    -e 's/\(\[WARN\].*\)/[1;33m\1[0m/g' \
 #   -e 's/\(\[INFO\].*\)/[1;34m\1[0m/g' \
  #  -e 's/\(\[ERROR\].*\)/[1;31m\1[0m/g'
#}

#alias mvn=color_maven
# thanks to:  http://blog.blindgaenger.net/colorize_maven_output.html
# and: http://johannes.jakeapp.com/blog/category/fun-with-linux/200901/maven-colorized
# Colorize Maven Output
alias maven="command mvn"
color_maven() {
  maven $* | sed -e 's/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/[1;32mTests run: \1[0m, Failures: [1;31m\2[0m, Errors: [1;33m\3[0m, Skipped: [1;34m\4[0m/g' \
    -e 's/\(\[WARN\].*\)/[1;33m\1[0m/g' \
    -e 's/\(WARN.*\)/[0;33m\1[0m/g' \
    -e 's/\(\[INFO\].*\)/[1;32m\1[0m/g' \
    -e 's/\(\[DEBUG\].*\)/[1;32m\1[0m/g' \
    -e 's/\(\[ERROR\].*\)/[1;31m\1[0m/g' \
    -e 's/\(BUILD FAILURE.*\)/[1;31m\1[0m/g' \
    -e 's/\(FAILURE!.*\)/[1;31m\1[0m/g' \
    -e 's/\(BUILD SUCCESS.*\)/[1;37m\1[0m/g' \
    -e 's/\(SUCCESS.*\)/[1;37m\1[0m/g' 
    
}
alias mvn=color_maven

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ls
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# new cmd
alias grepactivemq='ps axuf | grep activemq'
alias grepjmx='ps axuf | grep jmx'
alias grepjava='ps axuf | grep java'
alias tailf='tail -f'

# building
alias ant="ant -Dliberty.dir=${SCM_ENGINE}"
alias mci="mvn clean install"

# git
alias gc="git commit -m"
alias ga="git add"
alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias gl='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

# nav
alias .1='cd ..'
alias ..='cd ..'
alias .2='cd ../../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias ....='cd ../../../'
alias .4='cd ../../../../'
alias .....='cd ../../../../'
alias .5='cd ../../../../..'
alias ......='cd ../../../../'

# calculator with math support
alias bc='bc -l'

# sha1 digest
alias sha1='openssl sha1'

# Create parent directories on demand
alias mkdir='mkdir -pv'

# install  colordiff package :)
alias diff='colordiff'

# Make mount command output pretty and human readable format
alias mount='mount |column -t'

# Command short cuts to save time
# handy short cuts
alias h='history'
alias j='jobs -l'

# Create a new set of commands
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Set vim as default
alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'

# Control output of networking tool called ping
# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

# Show open ports
alias ports='netstat -tulanp'

# Control firewall (iptables) output
## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
 
# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# Debug web server / cdn problems with curl
# get web server headers #
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# Add safety nets
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Update Debian Linux server
# distro specific  - Debian / Ubuntu and friends #
# install with apt-get
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
 
# update on one command 
alias update='sudo apt-get update && sudo apt-get upgrade'

# Tune sudo and su
# become root #
alias root='sudo -i'
alias su='sudo -i'

# Pass halt/reboot via sudo
# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# Set default interfaces for sys admin related commands
# All of our servers eth1 is connected to the Internets via vlan / router etc  ##
alias dnstop='dnstop -l 5  eth1'
alias vnstat='vnstat -i eth1'
alias iftop='iftop -i eth1'
alias tcpdump='tcpdump -i eth1'
alias ethtool='ethtool eth1'
 
# work on wlan0 by default #
# Only useful for laptop as all servers are without wireless interface
alias iwconfig='iwconfig wlan0'

# Get system memory, cpu usage, and gpu memory info quickly
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
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# It's your turn to share
# Resume wget by default
# this one saved by butt so many times ##
alias wget='wget -c'

## set some other defaults ##
alias df='df -H'
alias du='du -ch'
 
# top is atop, just like vi is vim
alias top='atop'

function lt() { ls -ltrsa "$@" | tail; }
function psgrep() { ps axuf | grep -v grep | grep "$@" -i --color=auto; }
function fname() { find . -iname "*$@*"; }
function iptdrop() { sudo /sbin/iptables -I INPUT -s $1 -j DROP; }
function iptreject() { sudo /sbin/iptables -I INPUT -s $1 -j REJECT; }
function iptclear() { sudo /sbin/iptables -F; }
function s() { ssh appsc@$1; }

alias tarx='tar -zxvf'
alias tarz='tar -zcvf'

alias cdpr="cd ~/mfx_dev/projects/trunk"
