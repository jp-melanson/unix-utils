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
notification=false
interval=5
maxwait=600
expectedcode=200

# cli options parsing with getopt
if ! options=$(getopt -o h\?:e:i:m:n -l help,interval,maxwait,notif: -- "$@")
then exit 1 ; fi

# options handling
set -- $options
while [ $# -gt 0 ]
do
    case $1 in
    -e|--expectedcode) expectedcode="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -i|--interval) interval="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -m|--maxwait) maxwait="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -n|--notification) notification=true ;;
    -h|--help|-\?) echo -e "Usage: $0 [options] url" ; exit;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

# remaining option is url, ignore everything else for now
if [ -z $1 ]
  then echo "No url provided"; exit;
  else url="`echo $1 | sed -e "s/^'\\|'$//g"`"
fi

function curl_url ()
{
  # return http code from response, converting '000' code as 0
  http_code=$(curl --write-out %{http_code} --silent --output /dev/null $url)
}

function log ()
{
  # log to console, notification system if enabled
  echo "[WebServerMonitor] $1"
  if $notification ; then notify-send "WebServerMonitor" "$1" ; fi
}

curl_url
if (( $http_code == 0 || $http_code != $expectedcode ))
  then
    echo "Waiting for server at url [$url] to return status code [$expectedcode] every [$interval] seconds, waiting [$maxwait] seconds at most."
else
  log "Server returning expected code already"; exit 0;
fi

while (( $http_code == 0 || $http_code != $expectedcode ))
  do
    echo -n "."
    sleep $interval
    curl_url
    maxwait=`expr $maxwait - $interval`
    if [ $maxwait -le 0 ]
      then echo ""; log "Server did not respond in specified amout of time"; exit -1
    fi
done

log "Server is now returning expected code!"; exit 0
