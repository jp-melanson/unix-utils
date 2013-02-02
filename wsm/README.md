# wsm.sh

 This is a simple command-line utility script for web server monitoring.

 The script uses the HTTP response status code as the indicator.

## Requirements

 This script is for the bash shell and use:
 - getopt
 - sed
 - curl

### Example of usage:

Waiting for a web server to be ready to accept request for an application:
    ./wsm.sh localhost:3000/myapp/index.html

Enable verbose logging:
    ./wsm.sh -v localhost:3000/myapp/index.html

Enable notifications:
    ./wsm.sh -n localhost:3000/myapp/index.html

Specific polling interval of 2 seconds:
    ./wsm.sh -i 2 localhost:3000/myapp/index.html

Specific timeout 2 minutes:
    ./wsm.sh -t 120 localhost:3000/myapp/index.html

Specific timeout 2 minutes:
    ./wsm.sh -t 120 localhost:3000/myapp/index.html

Expect a specific HTTP code:
    ./wsm.sh -c 404 localhost:3000/myapp/inexistant.html

Just get the HTTP status code and exit:
    ./wsm.sh -m code localhost:3000/myapp/foo.html
