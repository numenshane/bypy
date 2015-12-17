#!/bin/bash

if [[ $# -eq 0 ]]; then
        echo "Usage: $0 outputFileName srcDownloadUrl"
        exit 0 
fi

dataSrc=/Data/tmp/
mkdir -p dataSrc
dataDestDir=/Data/youtube

dl="curl -# -L -o "

cd $dataSrc
echo curl -# -L -o "$1" "$2"
$dl "$1" "$2"

if [[ $? -eq 0 ]]; then 
        echo moving "$1" to $dataDestDir
        mv "$1" $dataDestDir/ 
fi
