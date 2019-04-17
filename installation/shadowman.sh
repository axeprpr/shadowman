#!/bin/bash
SHADOWMAN_DIR=/etc/shadowman
SHADOWMAN_CONFIG=/etc/shadowman/shadowman.ini
SHADOWMAN_SERVICES_DIR=$SHADOWMAN_DIR/services
SHADOWMAN_SCRIPTS_DIR=$SHADOWMAN_DIR/scripts

SUPPORT_SERVICES=$(ls -F $SHADOWMAN_SERVICES_DIR | grep '/' | cut -d'/' -f1)
SUPPORT_SCRIPTS=$(ls -F $SHADOWMAN_SCRIPTS_DIR --file-type | grep -v '/')

HELP="shadowman -s/-c <service/script> [action]... \n"

SUPPORT_SERVICES_HELP="shadowman -s <service> [action]... \n"
SUPPORT_SERVICES_HELP+="support services:\n"
SUPPORT_SERVICES_HELP+="$SUPPORT_SERVICES"

SUPPORT_SCRIPTS_HELP="shadowman -c <service> [action]... \n"
SUPPORT_SCRIPTS_HELP+="support scripts:\n"
SUPPORT_SCRIPTS_HELP+="$SUPPORT_SCRIPTS"

## ----- services function -----
# frpc
function frpc(){
    dir="$SHADOWMAN_SERVICES_DIR/frpc"
    case $1 in
        start|restart)
        pkill at_frpc
        nohup $dir/at_frpc -c $dir/at_frpc.ini 1>$dir/log 2>&1 &
        ;;
        stop)
        pkill at_frpc
        ;;
        config)
        vi $dir/at_frpc.ini
        ;;
        enable)
        [ ! -f $dir/enable ] && touch $dir/enable
        ;;
        disable)
        [ -f $dir/enable ] && rm -f $dir/enable
        ;;
        log)
        tail -20  $dir/log
        ;;
        *)
        echo "support actions: start stop restart config enable disable log"
    esac
}

function fileserver(){
    dir="$SHADOWMAN_SERVICES_DIR/fileserver"
    case $1 in
        start|restart)
        echo > $dir/log
        pkill at_fileserver
        fileserver_port=$(cat $dir/at_fileserver.ini | grep port | cut -d'=' -f2 | sed s/[[:space:]]//g)
        fileserver_dir=$(cat $dir/at_fileserver.ini | grep dir | cut -d'=' -f2 | sed s/[[:space:]]//g)
        echo $dir $fileserver_port $fileserver_dir > $dir/log
        nohup $dir/at_fileserver -port ":$fileserver_port" -dir $fileserver_dir 1>$dir/log 2>&1 &
        ;;
        stop)
        echo > $dir/log
        pkill at_fileserver
        ;;
        config)
        vi $dir/at_fileserver.ini
        ;;
        log)
        tail -20  $dir/log
        ;;
        *)
        echo "support actions: start stop restart config enable"
    esac
}

function autossh(){
    dir="$SHADOWMAN_SERVICES_DIR/autossh"
    case $1 in
        enable)
        sed -i '/assh=/d' ~/.bashrc
        echo "alias assh=$dir/autossh" >> ~/.bashrc
        source ~/.bashrc
        ;;
        disable)
        sed -i '/assh=/d' ~/.bashrc
        source ~/.bashrc
        ;;
        *)
        echo "support actions: enable disable"
    esac
}

## ----- service or script? -----
function func_services(){
    s=
    if [ -z $1 ];then
        echo -e $SUPPORT_SERVICES_HELP
        exit -1
    else
        for i in $SUPPORT_SERVICES;do
            if [ $1 == $i ];then
                s=$1
            fi
        done
    fi

    if [ -z $s ];then
        echo -e $SUPPORT_SERVICES_HELP
        exit -1
    else
        $s $2
    fi
}

function func_scripts(){
    c="$SHADOWMAN_SCRIPTS_DIR/"
    if [ -z $1 ];then
        echo -e $SUPPORT_SCRIPTS_HELP
        exit -1
    else
        for i in $SUPPORT_SCRIPTS;do
            if [ $1 == $i ];then
                c+=$1
            fi
        done
    fi

    if [ ! -f $c ];then
        echo -e $SUPPORT_SCRIPTS_HELP
        exit -1
    else
        shift 1
        $c $@
    fi
}

# main
case $1 in
    -s)
    func_services $2 $3
    ;;
    -c)
    shift 1
    func_scripts $@
    ;;
    *)
    echo $HELP
esac
