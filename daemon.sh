#!/bin/bash
execDir=/Data/bypy # bypy程序目录
logFile=$execDir/bypy.log # 日志文件
dataDir=/Data/youtube # 要远程同步上传至数据文件夹
pythonExec=/usr/local/bin/python2.7 # python binary (version > 2.7)

if  [[ `ps -elf|grep bypy|grep syncup|wc -l` -eq 0 ]]; then  
    echo `date` > $logFile
    $pythonExec $execDir/bypy.py syncup $dataDir >> $logFile 2>&1
    if [[ $? -eq 0 ]]; then
        echo "syncup down, clean and recycle local dir" >> $logFile
        rm -fr $dataDir/*
    else
        echo "Err: return status: $?" >> $logFile
    fi
else
    echo "bypy currently is running $(date)!" >> $logFile
fi
