#!/bin/bash
export PATH="/usr/local/bin/:/usr/local/mysql/bin:/usr/sbin:$PATH"
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
            *)
            echo "unknow arg"
            ;;
        esac
    done
}

ARGS="$@"
parse_config
echo "DATAPATH : $DATAPATH "
echo "PKG : $PKG "
echo "  : $ID "
echo "SECRETY : $SECRETY "
echo "ORIGIN : $ORIGIN "
echo "PORT : $PORT "
echo "NODEENV : $NODEENV "

restart(){
    cd $DATAPATH
    rm -rf master
    mkdir master
    tar -xvf $PKG -C master
    #rm -rf $PKG
    cd master
    export OAUTH_CLIENT_ID=$ID
    export OAUTH_CLIENT_SECRET=$SECRETY
    export ORIGIN=$ORIGIN
    export PORT=$PORT
    export NODE_ENV=$NODEENV

    echo "PID=$(lsof -t -i :$PORT)"
    APPPID="$(lsof -t -i :$PORT)" && A=1

    echo "xxx $APPPID"
    if [[ $APPPID != "" ]]; then
        echo "pid found: $APPPID"
        kill -9 $APPPID
        sleep 2
    fi
    echo "nohup node index.js >> local_log 2>&1 "
    nohup node index.js >> local_log 2>&1 &
    cd -
}
restart

