#screen -S pentaho -d -m -t shell bash
#screen -S pentaho -X screen -t logs bash

if [ -z "$DEBUG" ]; then
	echo Starting Pentaho in normal mode
	/pentaho/biserver-ce/start-pentaho.sh;
else
	echo Starting Pentaho in debug mode
	/pentaho/biserver-ce/start-pentaho-debug.sh;
fi

