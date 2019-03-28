#!/bin/sh
REMOTEKEYPATH="https://github.com/FibocomMbb/fwswitch/raw/master/apt/key/deb.gpg.key "
KEY="./.tmp_key"
REPOSITORY_PATH="deb https://github.com/FibocomMbb/fwswitch/raw/master/apt/ fwswitch main"
SOURCE_PATH="/etc/apt/sources.list"
if [ $(whoami) != "root" ]; then
	echo "Please run as root"
	exit 1
fi

wget -O $KEY $REMOTEKEYPATH  
rc=$?
if [ $rc -ne 0 ]; then
	echo "Download key failed, please check the Network, if Network is ok, please copy the output and connect Fibocom"
	exit 1
else
	echo "Update the fwswitch gpg key"
fi
cat $KEY | apt-key add -
rm $KEY

cat $SOURCE_PATH | grep "${REPOSITORY_PATH}"
rc=$?
if [ $rc -eq 0 ]; then
	echo "The repository url exist, NOT add it again"
else
	echo "The repository url NOT exist, add it in "$SOURCE_PATH
	echo $REPOSITORY_PATH | tee -a $SOURCE_PATH
fi

apt-get update
dpkg -r  fwswitchtool
echo "Now you can run \"sudo apt-get install fwswitchtool\" get or update the fwswitch"
