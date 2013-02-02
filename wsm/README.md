# About

 This is a simple command-line utility for web server monitoring.
 It uses status code of the HTTP response as the base metric.
 You can do stuff like:
 - Halt a script, make it wait for a web server to be available, shutted down.
 - Validate some web endpoints, heartbeat style.
 - Useful to get notifications, and avoid losing sight of what you were doing.

### Requirements

 This script is for the bash shell and use:
 - getopt
 - sed
 - curl

### Usage examples:

Waiting for a web server to be ready to accept request for an application:
```
./wsm.sh localhost:3000/myapp/index.html
```

Enable verbose logging:
```
./wsm.sh -v localhost:3000/myapp/index.html
```

Enable notifications:
```
./wsm.sh -n localhost:3000/myapp/index.html
```

Specific polling interval of 2 seconds:
```
./wsm.sh -i 2 localhost:3000/myapp/index.html
```

Specific timeout 2 minutes:
```
./wsm.sh -t 120 localhost:3000/myapp/index.html
```

Specific timeout 2 minutes:
```
./wsm.sh -t 120 localhost:3000/myapp/index.html
```

Expect a specific HTTP code:
```
./wsm.sh -c 404 localhost:3000/myapp/inexistant.html
```

Just get the HTTP status code and exit:
```
./wsm.sh -m code localhost:3000/myapp/foo.html
```

