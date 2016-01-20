#!/bin/bash

# This thing connects to box, checks the latest builds and downloads the client tools

#
# These are the variables that need to be set
#

#BOX_USER=pedro.alves@pentaho.com
#BOX_PASS=XXXXXX

if [ -z $BOX_USER ]
then
	echo The following variables have to be set:
  echo BOX_USER
  echo BOX_PASSWORD
  echo "Optionally, override BOX_URL (set to ftp.box.com/CI)"
  exit 1
fi

#VERSIONS=()
VERSIONS=(6.0-NIGHTLY 6.1.0.0)
BOX_URL=${BOX_URL:-ftp.box.com/CI}
DIR=clients


# Print a quick status of current dir
if ! [ -d $DIR ]
then
  echo No local client tools found
  echo
else
  echo Latest build found for client tools: $( ls -d $DIR/*/ | cut -f2 -d'/' | sort -n -r | head -n 1 )
fi

# Get list of files
echo Connecting to box...

for i in ${VERSIONS[@]}; do
	
	result=$(lftp -c "open -u $BOX_USER,$BOX_PASSWORD $BOX_URL ; cls -1 --sort date $i | head -n 1");

	BRANCH=$(echo $result | cut -f1 -d/)
	BUILD=$(echo $result | cut -f2 -d/)
	echo Build available - Branch: $BRANCH , Build number: $BUILD
done


echo 

# Ask for branch
read -e -p "Which branch to download from? [$BRANCH]: " branch
branch=${branch:-$BRANCH}

# Ask for buildno
read -e -p "Which build number? [$BUILD]: " buildno
buildno=${buildno:-$BUILD}


PRODUCTS=(pdi-ee pdi-ce prd-ee prd-ce pme-ee pme-ce psw-ee psw-ce pad-ee pad-ce)

echo Available client tools
echo

i=0
for p in ${PRODUCTS[@]} 
do
  echo [$i]: $p
  ((i++))
done
echo


# Ask for product
read -e -p "Which client tool to download? [0]: " productIdx
product=${PRODUCTS[$productIdx]}

if [ -z $product ]
then
  echo Invalid selection
  exit 1
fi


tooldir=$DIR/$product/$branch/$buildno

echo you selected $product. Downloading to $tooldir

if [ -d $tooldir ]
then
  echo Dir already exists. Won\'t download again
  exit 1
else
  mkdir -p $tooldir
fi

# Downloading...

lftp -c "lcd $tooldir; open -u $BOX_USER,$BOX_PASSWORD $BOX_URL ; \
  cd $BRANCH/$BUILD; \
  get $product-$branch-$buildno.zip \
  ";

unzip $tooldir/$product-$branch-$buildno.zip -d $tooldir
echo rm $tooldir/$product-$branch-$buildno.zip 

echo Done. 

exit 0
