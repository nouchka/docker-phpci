#!/bin/bash

wait_file() {
  local file="$1"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout

  until test $((wait_seconds--)) -eq 0 -o ! -f "$file" ; do sleep 1; done

  ((++wait_seconds))
}

phpci_touch=/var/log/init.touch

##Wait if main container 
##TODO maybe add flag 

sleep 20

wait_file "$phpci_touch" 300 || {
  echo "Still initializing after $? seconds: exit"
  exit 1
}

cd /var/www/phpci/

php ./daemonise phpci:daemonise
