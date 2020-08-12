#!/bin/bash
set -e
parse_config() {
    for arg in ${ARGS}
    do
        case ${arg} in
            --data_path=*)
            DATAPATH="${arg#*=}"
            ;;
            --pkg=*)
            PKG="${arg#*=}"
            ;;
            --id=*)
            ID="${arg#*=}"
            ;;
            --secrety=*)
            SECRETY="${arg#*=}"
            ;;
            --origin=*)
            ORIGIN="${arg#*=}"
            ;;
            --port=*)
            PORT="${arg#*=}"
            ;;
            --node_env=*)
            NODEENV="${arg#*=}"
            ;;
            echo "unknow arg"
            ;;
            *)

        esac
    done
}

ARGS="$@"
parse_config
echo "DATAPATH : $DATAPATH "
echo "PKG : $PKG "
echo "ID : $ID "
echo "SECRETY : $SECRETY "
echo "ORIGIN : $ORIGIN "
echo "PORT : $PORT "
echo "NODEENV : $NODEENV "

restart(){
    echo "kp :$(lsof -t -i :3000)" 
    kill -9 "$(lsof -t -i :3000)" 
    cd $DATAPATH 
    rm -rf master 
    mkdir master  
    tar -xvf $PKG -C master 
    rm -rf $PKG 
    cd master 
    export OAUTH_CLIENT_ID=$ID 
    export OAUTH_CLIENT_SECRET=$SECRETY 
    export ORIGIN=$ORIGIN 
    export PORT=$PORT 
    export NODE_ENV=$NODEENV 
    nohup node index.js >> local_log 2>&1 & 
}
