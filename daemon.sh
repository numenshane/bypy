#!/bin/bash
execDir=/Data/bypy # bypy程序目录
dataDir=/Data/youtube # 要远程同步上传至数据文件夹
pythonExec=/usr/local/bin/python2.7 # python binary (version > 2.7)

echo +++ $0 `date` this round started
if  [[ `ps -elf|grep "$execDir/bypy.py" |grep upload|wc -l` -eq 0 ]]; then  
    cd $dataDir
    #recording the current file numbers
    find . -name "*" -exec bash -c '/usr/bin/rename_pl "s/ |:|,|&|;|\(|\)|\[|\]|\\\//g" "$1"' -- {} \;
    find . -maxdepth 1 -type f -exec bash -c 'if [ "$1" != "." ]; then /usr/local/bin/python2.7 /Data/bypy/bypy.py upload "$1" && rm -fr "$1"; fi' -- {} \;  
    find . -maxdepth 1 -type d -exec bash -c 'if [ "$1" != "." ]; then /usr/local/bin/python2.7 /Data/bypy/bypy.py upload "$1" `date +%Y-%m-%d` && rm -fr "$1"; fi' -- {} \;  

    #lines_bef=`ls -l|wc -l`
    #$pythonExec $execDir/bypy.py syncup $dataDir 
    #if [[ $? -eq 0 ]]; then
#	lines_cur=`ls -l|wc -l`
#	if [ $lines_bef -eq $lines_cur ]; then 
 #           echo "`date` syncup completed"
#	    echo "remove files below"
#	    echo `find . -type f`
 #           rm -fr $dataDir/*
#	else
#	    echo "$(date) adding more files during sync time, so don't clean $dataDir right now, delay to next time"	
#	fi
 #   else
  #      echo "$(date) Err: return status: $?"
   # fi
else
    echo "$(date) another bypy instances is running concurrently, just exited!"
fi
echo --- $0 `date` this round ended
