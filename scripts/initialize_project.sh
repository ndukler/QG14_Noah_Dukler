#!/usr/bin/env bash

home=`pwd`

cd $1
mkdir -p downloads
mkdir -p lib

cd downloads

while read file; do
    echo $file
    wget -N $file
    if [[ $file =~ \.zip$ ]]; then
	base=`basename $file`
	unzip -o $base
    fi
done < <(sed 's/\s\+//g' $home/$2 | cut -d "=" -f2)



