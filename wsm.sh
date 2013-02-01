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
stdout=true
notification=false
interval=5
maxwait=600
expectedcode=200
usage="Usage: $0 [options...] <url>"
usage="${usage}\nOptions:"
usage="${usage}\n\t-h, --help\t\t\t\tDisplay help."
usage="${usage}\n\t-e, --expectedcode [HTTP STATUS CODE]\tHTTP status code expected to consider web server up."
usage="${usage}\n\t-i, --interval [TIME]\t\t\tPolling interval (in seconds)."
usage="${usage}\n\t-m, --maxwait [TIME]\t\t\tMaximum amount of time (in seconds) to wait for the web server to provide the expected status code."
usage="${usage}\n\t-n, --notif\t\t\t\tEnable notify-send notifications."
usage="${usage}\n\t-o, --notifonly\t\t\t\tEnable notify-send notifications, but not stdio logging."


# cli options parsing with getopt
if ! options=$(getopt -o h\?:e:i:m:no -l help,expectedcode,interval,maxwait,notif,notifonly: -- "$@")
then exit 1 ; fi

# options handling
set -- $options
while [ $# -gt 0 ]
do
    case $1 in
    -e|--expectedcode) expectedcode="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -i|--interval) interval="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -m|--maxwait) maxwait="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -n|--notif) notification=true ;;
    -o|--notifonly) notification=true; stdout=false ;;
    -h|--help|-\?) echo -e "$usage" ; exit;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

function log ()
{
  # log to console, notification system if enabled
  if $stdout ; then echo "[WebServerMonitor] $1" ; fi
  if $notification ; then notify-send -t 20000 "WebServerMonitor" "$1" ; fi
}

# remaining option is url, ignore everything else for now
if [ -z $1 ]
  then log "No url provided"; exit;
  else url="`echo $1 | sed -e "s/^'\\|'$//g"`"
fi

function curl_url ()
{
  # return http code from response, converting '000' code as 0
  http_code=$(curl --write-out %{http_code} --silent --output /dev/null $url)
}

curl_url
if (( $http_code == 0 || $http_code != $expectedcode ))
  then
    log "Waiting for server at url [$url] to return status code [$expectedcode] every [$interval] seconds, waiting [$maxwait] seconds at most."
else
  log "Server returning expected code already"; exit 0;
fi

while (( $http_code == 0 || $http_code != $expectedcode ))
  do
    if $stdout ; then echo -n "." ; fi
    sleep $interval
    curl_url
    maxwait=`expr $maxwait - $interval`
    if [ $maxwait -le 0 ]
      then
        if $stdout ; then echo "" ; fi
        log "Server did not respond in specified amout of time";
        exit -1
    fi
done

if $stdout ; then echo "" ; fi
log "Server is now returning expected code!"
exit 0
