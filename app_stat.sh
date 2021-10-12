#!/bin/bash
source ~/.bashrc
$source /home/pelatro/install/mViva/product/utilities/CheckProcessList.cfg
source ./CheckProcessList.cfg
SKDEF='\e[39m'
SKBLK='\e[30m'
SKRED='\e[31m'
SKGRN='\e[32m'
SKYLW='\e[33m'
SKBLU='\e[34m'
SKMAG='\e[35m'
SKCYN='\e[36m'
SKIND='\e[37m'
SKDGR='\e[90m'
SKLRD='\e[91m'
SKLGR='\e[92m'
SKLYW='\e[93m'
SKLBL='\e[94m'
SKLMG='\e[95m'
SKLCY='\e[96m'
SKWHI='\e[97m'
if [[ $1 == 'all' ]]
then
        echo -e "\n${SKMAG}\e[1;47m                                       Application Process Status                                        \033[0m\n"
	for i in ${hosts//,/ };
	do
		`echo ssh  $i|sed s/:/' '/g`
	done
else
CPU_USAGE=`sar -f $(date +/var/log/sa/sa%d) -u|tail -1|awk '{print $8"%"}'`
MEMUSED=`free -m|tail -2|head -1|awk '{print $3}'`
MEMTOTAL=`free -m|grep Mem:|awk '{print $2}'`
#MEM=`echo "$MEMUSED/$MEMTOTAL*100"|bc -l|awk -F '.' '{print $1"%"}'`
MEM=`echo "$MEMUSED,$MEMTOTAL,100" | awk -F"," '{printf("%.2f\n",$1/$2*$3)}'`
echo -e "${SKBLU}\e[1;47m                                       `hostname`                                        \033[0m\n"
echo -e "${SKDGR}\e[1;47m`printf "%32s [%8s] %25s [%8s]%25s" "CPU USAGE:" "$CPU_USAGE" "MEMORY USAGE:" "${MEM}%" `${SKDGR}${SKDEF}\e[0m"

echo -e "${SKMAG}`printf "%35s [%8s] [%8s] [%4s] [%10s] [%10s] [%6s]\n" "Process Name" "Instance" "PID" "CPU" "Alloc RAM" "Util RAM" "STATUS"`${SKMAG}${SKDEF}\e[0m"
for i in ${APP_PROCESS//,/ }
do

grepString=`echo $i|awk -F ':' '{print $NF}'`
displayString=`echo $i|awk -F ':' '{print $1}'`
process_type=`echo $i|awk -F ':' '{print $2}'`
status=`ps -ef | grep $PRODUCT_USER | grep -w "${grepString}" |grep -v grep`
if [ $? -eq 1 ]
then
 echo -e "${SKRED}`printf "%35s [%8s] [%8s]" "${displayString}" "N/A" "N/A"`${SKDEF} ${SKRED}`printf "[%4s] [%10s] [%10s] [%6s]\n" "N/A" "N/A" "N/A" "DEAD"`${SKRED}${SKDEF}\e[0m"
else
PIDS=`ps -ef|grep $PRODUCT_USER|grep -w ${grepString}|grep -v grep|awk '{print $2}'`
instance=1
for PID in $PIDS
do
alocated=`jstat -gc ${PID}|awk 'NR==2{print $7}' | cut -d"." -f1`
utilized=`jstat -gc ${PID}|awk 'NR==2{print $8}' | cut -d"." -f1`
cpu=`ps -aux|grep -w ${PID}|grep -v grep|awk '{print $3}'`

if [ $alocated -le $utilized ]
then
echo -e "${SKBLU}`printf "%35s [%8s] [%8s]" "${displayString}" "$instance" "$PID"`${SKDEF} ${SKRED}`printf "[%4s] [%10s] [%10s] [%6s]\n" "$cpu" "$alocated" "$utilized" "ALERT"`${SKRED}${SKDEF}\e[0m"
else
echo -e "${SKBLU}`printf "%35s [%8s] [%8s]" "${displayString}" "$instance" "$PID"`${SKDEF} ${SKGRN}`printf "[%4s] [%10s] [%10s] [%6s]\n" "$cpu" "$alocated" "$utilized" "OK"`${SKGRN}${SKDEF}\e[0m"
fi
instance=`echo $(($instance+1))`
done
fi
done
fi

