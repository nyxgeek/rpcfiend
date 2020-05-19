#!/bin/bash
# a simple tool to pull down info via rpc null session with rpcclient
# 2020.05.19 @nyxgeek - TrustedSec

# usage: ./rpcfiend.sh 192.168.1.1

if [ $# -eq 0 ]; then
        echo "No parameters supplied."
        echo "Usage: ./rpcfiend.sh 192.168.1.1"
        exit 1
fi

HOST=$1

##### get domain admins ######
function get_domain_admins(){

        DA_RID_ARRAY=`rpcclient -U '' -N $HOST -c "querygroupmem 0x200" | sed 's/rid:\[//g' | tr -d ']' | sed 's/attr:\[0x7//g'`
        DA_ARRAY=`rpcclient -U '' -N $HOST -c "samlookuprids domain $DA_RID_ARRAY"`

        echo "+++++++++ DOMAIN ADMINS +++++++++"
        for ((i = 0; i < ${#DA_ARRAY[@]}; i++)); do
                echo "${DA_ARRAY[$i]}" | cut -d' ' -f3 | tee -a rpcfiend_domain_admins.txt
        done

}

##### get domain controllers ######
function get_domain_controllers(){
        DC_RID_ARRAY=`rpcclient -U '' -N $HOST -c "querygroupmem 0x204" | sed 's/rid:\[//g' | tr -d ']' | sed 's/attr:\[0x7//g'`
        DC_ARRAY=`rpcclient -U '' -N $HOST -c "samlookuprids domain $DC_RID_ARRAY"`

        echo "+++++++++ DOMAIN CONTROLLERS +++++++++"
        for ((i = 0; i < ${#DC_ARRAY[@]}; i++)); do
                echo "${DC_ARRAY[$i]}" | cut -d' ' -f3 | tee -a rpcfiend_domain_controllers.txt
        done

}

##### get domain machines ######
function get_domain_machines(){
        DM_RIDS=`rpcclient -U '' -N $HOST -c "querygroupmem 0x203" | sed 's/rid:\[//g' | tr -d ']' | sed 's/attr:\[0x7//g'`
        DM_RID_ARRAY=($DM_RIDS)

        echo "The array contains ${#DM_RID_ARRAY[@]} items"
        echo "+++++++++ DOMAIN MACHINES +++++++++"

        #let's use a maxsize of 500 items per query bc too much will result in rpcclient error
        maxarraycount=${#DM_RID_ARRAY[@]}
        arraystart=0
        arrayend=500
        arraycount=500
        while [ $arrayend -lt $maxarraycount ]; do
                echo "Testing from $arraystart to $arrayend"
                temparray=(${DM_RID_ARRAY[@]:$arraystart:$arraycount})

                #flatten the array into a string
                tempstring=`echo "${temparray[@]}"`
                rpcclient -U '' -N $HOST -c "samlookuprids domain $tempstring" | cut -d ' ' -f3 | tee -a rpcfiend_domain_machines.txt
                arraystart=$(( $arraystart + $arraycount ))
                arrayend=$(( $arrayend + $arraycount ))
                #echo "Arraystart is now $arraystart and Arrayend is now $arrayend"
        done

}

get_domain_admins
get_domain_controllers
get_domain_machines

echo "Results can be found in rpcfiend_domain_*.txt"
