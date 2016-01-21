#screen -S pentaho -d -m -t shell bash
#screen -S pentaho -X screen -t logs bash

sudo /etc/init.d/postgresql start


export PENTAHO_INSTALLED_LICENSE_PATH=/home/pentaho/.pentaho/.installedLicenses.xml

if [ -z "$DEBUG" ]; then
  echo Starting Pentaho in normal mode
  cd /pentaho/biserver-*
  ./start-pentaho.sh;
else
  echo Starting Pentaho in debug mode
  cd /pentaho/biserver-*
  ./start-pentaho-debug.sh;
fi

