#!/bin/bash
export PATH="/sbin/:/bin:/usr/sbin/:/usr/bin:/usr/local/bin"
export TERM=xterm
flow=`/bin/bash /Data/bypy/network-analysis.sh eth0 |grep 'eth0 Transmit'|awk -F" " '{print $3}'|sed -n 's/Kb\/s//p'|sed -n 's/\.[0-9]*//p'`
if [[ $flow -lt 100 ]]; then
	echo "`date` eth0 15s average networkflow:${flow}Kb 太小 -> 外部对接的上传服务（如百度云）对该实例端口限流了 -> 重启实例 使用随机端口"
	pkill find
	pkill bypy
else
	echo "`date` eth0 15s average networkflow:${flow}Kb 正常" 
fi
