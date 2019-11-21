#!/bin/bash
execDir=/Data/bypy 
if [ $# -eq 0 ]; then 
    echo "please input local sync dir"
    exit; 
fi

function safely_clean {
	bypy search `echo "$1"|sed 's/^\.\///'`|grep -i 'Nothing found' >> /dev/null
	if [ $? -ne 0 ]; then 
		rm -fr "$1";
		echo "$(date) safely remove $1"
	fi
}

mkdir -p $1
dataDir=$1 #local sync data path
pythonExec=/usr/bin/python2.7 # python binary (version > 2.7)

echo "******++++" `date` $0 $@ this round started

mkdir -p /var/bypy
pidFile=/var/bypy/`echo "$1" | sed 's/\//_/g' | sed 's/ //g'`.pid
if [ ! -e "$pidFile" ]; then  
    echo $$ > "$pidFile"
    cd $dataDir
    find . -maxdepth 1 -type f -exec bash -c 'if [ "$1" != "." ]; then bypy upload "$1"; fi' -- {} \; -exec \
	bash -c 'f=$(echo "$1"|sed "s/^\.\///"); bypy search "$f"|grep -vi "Nothing found" >> /dev/null && rm -fr "$1" && echo $(date) safely remove "$1" ' -- {} \;
    # ---pending, imp upload local dir to remote dir which is not named by `date +%Y-%m-%d` 
    find . -maxdepth 1 -type d -exec bash -c 'if [ "$1" != "." ]; then bypy upload "$1" `date +%Y-%m-%d` && rm -fr "$1"; fi' -- {} \;  
    rm "$pidFile"
else
    ps -elf|grep bypy|grep `cat $pidFile` >> /dev/null
    if [ $? -eq 0 ]; then 
    	echo "$(date) another bypy instances is running concurrently, just exited!"
    else
	echo "$(date) remove not exited instances in $pidFile" 
        rm -f "$pidFile"
    fi
fi

echo "******----" `date` $0 $@ this round ended
