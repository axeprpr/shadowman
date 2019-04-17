#!/bin/bash
WORK_DIR=$(cd `dirname $0`; pwd)

VERSION_NO=1.0.0
CODEDIR=shadowman

[ -z $BUILD_NUMBER ] && BUILD_NUMBER=0
[ -z $GIT_COMMIT ] && GIT_COMMIT="null"

cd $WORK_DIR

# clean bins
rm -f $WORK_DIR/*.bin
rm -f $WORK_DIR/*.md5
makeself=$WORK_DIR/installation/makeself/makeself.sh

# make shadowman.bin
$makeself --gzip $WORK_DIR/installation shadowman.$BUILD_NUMBER.bin shadowman  ./setup.sh
chmod +x shadowman.$BUILD_NUMBER.bin
md5sum shadowman.$BUILD_NUMBER.bin > shadowman.$BUILD_NUMBER.bin.md5


