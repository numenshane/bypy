#!/bin/bash
execDir=/Data/bypy # bypy程序目录
# logFile=$execDir/bypy.internal.log # 日志文件
dataDir=/Data/youtube # 要远程同步上传至数据文件夹
pythonExec=/usr/local/bin/python2.7 # python binary (version > 2.7)

echo +++ $0 `date` this round started
if  [[ `ps -elf|grep bypy|grep syncup|wc -l` -eq 0 ]]; then  
    cd $dataDir
    #recording the current file numbers
    lines_bef=`ls -l|wc -l`
    $pythonExec $execDir/bypy.py syncup $dataDir 
    if [[ $? -eq 0 ]]; then
	lines_cur=`ls -l|wc -l`
	if [ $lines_bef -eq $lines_cur ]; then 
            echo "`date` syncup down, clean and recycle local dir"
            rm -fr $dataDir/*
	else
	    echo "$(date) adding more files during sync time, so don't clean $dataDir right now, delay to next time"	
	fi
    else
        echo "$(date) Err: return status: $?"
    fi
else
    echo "$(date) bypy currently is running !"
fi
echo --- $0 `date` this round ended
