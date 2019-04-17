#!/bin/bash -x
WORK_DIR=$(cd `dirname $0`; pwd)
SHADOWMAN_DIR=/etc/shadowman

if [ `whoami` != "root" ];then  
    echo "Need root."
    exit -1  
fi

if [ -d $SHADOWMAN_DIR ];then
    rm -rf $SHADOWMAN_DIR
fi

if [ -f /usr/bin/shadowman ];then
    rm -f /usr/bin/shadowman
fi
    
mkdir $SHADOWMAN_DIR
cp -rf services /etc/shadowman/
cp -rf scripts /etc/shadowman/
cp -f ./shadowman.sh /usr/bin/sd
cp -f ./shadowman.ini /etc/shadowman/shadowman.ini
chmod +x /usr/bin/sd

