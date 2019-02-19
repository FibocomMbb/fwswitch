#!/bin/sh

ERROR_NO_DEB="ERROR:The package.deb should at "
ERROR_REP_EXPORT="ERROR:reprepro export error"
ERROR_REP_CLUDE_DEB="ERROR:reprepro include deb file error"
debfile="package.deb"

path=$(pwd)
if [ ! -f $debfile ]; then
	echo $ERROR_NO_DEB${path}"/"
	exit 1
fi      	

cd ./apt/
rm db dists/ pool/ -rf
cd $path

reprepro --ask-passphrase -Vb ./apt export
rc=$?
if [ $rc -ne 0 ]; then
	echo $ERROR_REP_EXPORT
	exit 1
fi

reprepro --ask-passphrase -Vb ./apt/  includedeb fwswitch ./$debfile
rc=$?
if [ $rc -ne 0 ]; then
	echo $ERROR_REP_CLUDE_DEB
	exit 1
fi      	
rm ./$debfile
