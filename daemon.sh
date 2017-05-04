#!/bin/bash
execDir=/Data/bypy # bypy程序目录
if [ $# -eq 0 ]; then 
    echo "please input local sync dir"
    exit; 
fi
mkdir -p $1
dataDir=$1 # 要远程同步上传至数据文件夹
pythonExec=/usr/bin/python2.7 # python binary (version > 2.7)

echo +++ $0 `date` this round started
mkdir -p /var/bypy
pidFile=/var/bypy/`echo "$1" | sed 's/\//_/g' | sed 's/ //g'`.pid
if [ ! -e "$pidFile" ]; then  
    echo $$ > "$pidFile"
    cd $dataDir
    find . -maxdepth 1 -type f -exec bash -c 'if [ "$1" != "." ]; then /usr/local/bin/bypy upload "$1"; rm -fr "$1"; fi' -- {} \;  
    # ---pending, imp upload local dir to remote dir which is not named by `date +%Y-%m-%d` 
    find . -maxdepth 1 -type d -exec bash -c 'if [ "$1" != "." ]; then /usr/local/bin/bypy upload "$1" `date +%Y-%m-%d` && rm -fr "$1"; fi' -- {} \;  
    rm "$pidFile"
else
    ps -elf|grep bypy|grep `cat $pidFile`
    if [ $? -eq 0 ]; then 
    	echo "$(date) another bypy instances is running concurrently, just exited!"
    else
	echo "remove not exited instances in $pidFile" 
        rm -f "$pidFile"
    fi
fi

echo --- $0 `date` this round ended
