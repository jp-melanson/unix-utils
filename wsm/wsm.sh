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

MODE_POLL="poll" # continous polling for the http status code
MODE_CODE="code" # fetch http status code once and exit
NOTIFICATIONS_EXPIRE_TIME=20000 # 20 seconds

# defaults for options
code=200
debug=false
interval=5
mode=$MODE_POLL
notifications=false
timeout=600
verbose=false

usage="Usage: $0 [options...] <url>"
usage="${usage}\nOptions:"
usage="${usage}\n\t-c, --code [HTTP STATUS CODE]\tHTTP status code to expect from web server."
usage="${usage}\n\t-d, --debug\t\t\tDebug mode combined with verbose will print extra details."
usage="${usage}\n\t-h, --help\t\t\tDisplay help."
usage="${usage}\n\t-i, --interval [TIME]\t\tPolling interval (in seconds)."
usage="${usage}\n\t-m, --mode [MODE]\t\t\"$MODE_POLL\" waits for expected code until a timeout occurs, \"$MODE_CODE\" fetch code once."
usage="${usage}\n\t-n, --notifications\t\tEnable notify-send notifications."
usage="${usage}\n\t-t, --timeout [TIME]\t\tMaximum amount of time (in seconds) to wait for the expected status code."
usage="${usage}\n\t-v, --verbose\t\t\tVerbose (details about on-going process to stdout)."


# cli options parsing with getopt
if ! options=$(getopt -o c:dh\?:i:m:nt:v -l code,help,interval,mode,notifications,timeout,verbose: -- "$@")
then exit 1 ; fi

# options handling
set -- $options
while [ $# -gt 0 ]
do
    case $1 in
    -c|--code) code="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -d|--debug) debug=true ;;
    -h|--help|-\?) echo -e "$usage" ; exit;;
    -i|--interval) interval="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -m|--mode) mode="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -n|--notifications) notifications=true ;;
    -t|--timeout) timeout="`echo $2 | sed -e "s/^'\\|'$//g"`" ; shift ;;
    -v|--verbose) verbose=true ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

# remaining option is url, ignore everything else for now
if [ -z $1 ]
  then log "No url provided"; exit;
  else url="`echo $1 | sed -e "s/^'\\|'$//g"`"
fi

# Log to console if verbose mode is enabled.
# Also send out notifications if enabled
function log ()
{
  if $verbose ; then echo "[WebServerMonitor] $1"; fi
  if $notifications ; then notify-send -t $NOTIFICATIONS_EXPIRE_TIME "WebServerMonitor" "$1"; fi
}

# Send a HTTP HEAD request to get web server status.
function curl_url ()
{
  result=`curl --write-out %{http_code} --silent --output /dev/null $url | sed s/000/0/`
}

curl_url
if $debug ; then echo $result; fi

# code only mode
if [ $mode == $MODE_CODE ] ; then echo $result; exit 0; fi
# unsupported mode
if [ $mode != $MODE_POLL ] ; then echo "Unsupported mode, use one of [$MODE_POLL, $MODE_CODE]"; exit 1; fi
# poll mode
if (( $result != $code ))
  then
    log "Polling web server at url [$url] for expected response code [$code] every [$interval] seconds and waiting [$timeout] seconds at most."
else log "Web server already responding with expected status code [$code]"; exit 0; fi

# begin polling
remaining=`expr $timeout`
while (( $result != $code ))
  do
    if $verbose ; then echo -n "." ; fi
    remaining=`expr $remaining - $interval`
    if [ $remaining -le 0 ]
      then
        if $verbose ; then echo "" ; fi
        log "Time is out, server did not respond in time with expected status code [$code]."
        exit 0
    fi
    sleep $interval
    curl_url
    if $debug ; then echo $result; fi
done

if $verbose ; then echo "" ; fi
log "Server has returned expected status code [$code]."
exit 0
