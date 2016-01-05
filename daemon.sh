#!/bin/bash
execDir=/Data/bypy # bypy程序目录
logFile=$execDir/bypy.log # 日志文件
dataDir=/Data/youtube # 要远程同步上传至数据文件夹
pythonExec=/usr/local/bin/python2.7 # python binary (version > 2.7)

if  [[ `ps -elf|grep bypy|grep syncup|wc -l` -eq 0 ]]; then  
    echo `date` > $logFile
    cd $dataDir
    #recording the current file numbers
    lines_bef=`ls -l|wc -l`
    $pythonExec $execDir/bypy.py syncup $dataDir >> $logFile 2>&1
    if [[ $? -eq 0 ]]; then
	lines_cur=`ls -l|wc -l`
	if [ $lines_bef -eq $lines_cur ]; then 
            echo "syncup down, clean and recycle local dir" >> $logFile
            rm -fr $dataDir/*
	else
	    echo "$(date) adding more files during sync time, so don't clean $dataDir right now, delay to next time"	
	fi
    else
        echo "$(date) Err: return status: $?" >> $logFile
    fi
else
    echo "$(date) bypy currently is running !" >> $logFile
fi
