#screen -S pentaho -d -m -t shell bash
#screen -S pentaho -X screen -t logs bash

sudo /etc/init.d/postgresql start




if [ -z "$DEBUG" ]; then
  echo Starting Pentaho in normal mode
  /pentaho/biserver-ee/start-pentaho.sh;
else
  echo Starting Pentaho in debug mode
  /pentaho/biserver-ee/start-pentaho-debug.sh;
fi

