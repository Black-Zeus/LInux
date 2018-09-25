#!/bin/bash
host="10.101.0.210" ##IP o dominio del server
mail="vsoto@tecnocomp.cl" ##mail donde recibirás los avisos.
status=$(fping $host)
status=$(echo $status | awk '{print $3}')
if [ -e /tmp/status-$host.txt ]
  then
    laststatus=$(cat /tmp/status-$host.txt)
    if [[ $laststatus != $status ]]
      then
        echo $status > /tmp/status-$host.txt
        if [[ $status = "alive" ]]
          then
            echo "Hi, the server $host is back up." | mail -s "The server $host is UP !" $mail
        else
          echo "Hi, the server $host is down." | mail -s "he server $host is DOWN !" $mail
        fi
    fi
else
  echo $status > /tmp/status-$host.txt
fi
