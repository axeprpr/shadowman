if [ -z $BUILD_NUMBER ] || [ -z $JOB_NAME ]; then
   echo "Not in jenkins!"
   exit -1
fi

IDENTITY=fileserver@192.222.1.150
FILEDIR=/home/fileserver/files/jenkins/$JOB_NAME
ssh $IDENTITY mkdir -p $FILEDIR/latest $FILEDIR/$BUILD_NUMBER
scp -r ./*.bin $IDENTITY:$FILEDIR/$BUILD_NUMBER/
scp -r ./*.md5 $IDENTITY:$FILEDIR/$BUILD_NUMBER/
ssh $IDENTITY rm -rf $FILEDIR/latest/*
scp -r ./*.bin $IDENTITY:$FILEDIR/latest/
scp -r ./*.md5 $IDENTITY:$FILEDIR/latest/