#!/bin/bash
##################################################################################################
# Copyright (C) 2013 Jean-Philippe Melanson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##################################################################################################

# defaults for options
ident=$0
notification=false
interval=2
maxwait=300

# cli options parsing with getopt
if ! options=$(getopt -o h\?:i:m:n -l help,interval,maxwait,notif: -- "$@")
then exit 1 ; fi

# options handling
set -- $options
while [ $# -gt 0 ]
do
    case $1 in
    -i|--interval) interval="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -m|--maxwait) maxwait="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -n|--notification) notification=true ; shift;;
    -h|--help|-\?) echo -e "Usage: $0 [options] url" ; exit;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

# remaining option is url, ignore everything else
url=$1

# return http code from response, converting '000' code as 0
function curl_url ()
{
  echo "`curl -sL -w %{http_code} -I \"$url\" -o /dev/null | sed s/000/0/`"
}

function log ()
{
  echo "$1"
  if [ $notification ]
    then notify-send "$ident" "$1" ; fi
}

http_code=`curl_url`
if [ $http_code -ge 500 -o $http_code -eq 0 ]
  then
    echo "Waiting for web server [$url] to become available every $interval seconds, waiting $maxwait seconds at most."
else
  log "Web server already [$url] responding. Exiting"
  exit 0
fi

while [ $http_code -ge 500 -o $http_code -eq 0 ]
  do
    http_code=`curl_url`
    echo -n "."
    sleep $interval
    maxwait=`expr $maxwait - $interval`
    if [ $maxwait -le 0 ]
      then
        echo ""
        log "Waited maximum amount of time and server is still unresponding. Exiting"
        exit -1
    fi
done

log "Server is now responding!"
exit 0
