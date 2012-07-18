#!/bin/sh


SBOX_HOME=/scratchbox/users/$USER/home/$USER
PROJECTFOLDER_HOST=$(pwd -P)
if [ $(basename $PROJECTFOLDER_HOST) = "tools" ]; then
    PROJECTFOLDER_HOST=$(cd .. && pwd -P)
fi

# Options
PROJECTFOLDER=$(basename $PROJECTFOLDER_HOST)-tmp
IP=192.168.2.15
USERNAME="developer"

# Flags
BUILD_ONLY=0
DEBIAN=0
RUN=0
CLEAN=0

HELP="Usage: ./build-deploy [options]\n
Copies the current directory to scratchbox, build, send and run Snowshoe on the N9.\n
Alternatively, a debian package can be generated and installed.\n
\n
Options:\n
\n
-b\t\t\tonly build the project, do not send to the device\n
-c\t\t\tmake distclean before building (only without -d)\n
-d\t\t\tgenerate debian package instead of single executable\n
-h\t\t\tshows this help message.\n
-i IP\t\t\tip of the target N9/N950 device\n
-u USERNAME\t\tset username to connect\n
-p FOLDER\t\tname of the temporary folder\n
-r\t\t\trun the executable after copying (without -b)
"


while getopts p:i:u:bdrch ARG
do case "$ARG" in
    p) PROJECTFOLDER="$OPTARG";;
    i) IP="$OPTARG";;
    u) USERNAME="$OPTARG";;
    b) BUILD_ONLY=1;;
    d) DEBIAN=1;;
    r) RUN=1;;
    c) CLEAN=1;;
    h) echo -e $HELP && exit 0;;
    ?) echo -e $HELP && exit 1;;
esac
done

# N9 configuration. This is the default ip for USB connections.
N9=$USERNAME@$IP
N9HOME=/home/$USERNAME

# Sync with build folder
echo "rsync $PROJECTFOLDER_HOST to $SBOX_HOME/$PROJECTFOLDER"
rsync -azrptL --progress --exclude-from=".gitignore" --exclude ".git" $PROJECTFOLDER_HOST/ $SBOX_HOME/$PROJECTFOLDER

if test $DEBIAN -eq 1; then
    BUILD_COMMAND="dpkg-buildpackage -rfakeroot -uc -us -B"
else
    BUILD_COMMAND="qmake && make -j 3"
    if test $CLEAN -eq 1;then
        BUILD_COMMAND="make distclean; $BUILD_COMMAND"
    fi
fi

LOGFILE=/tmp/$PROJECTFOLDER-build.txt

# Build project
/scratchbox/login -s <<EOF
cd $PROJECTFOLDER
export PATH=/opt/qt5/bin:\$PATH
$BUILD_COMMAND 2>&1 | tee $LOGFILE
EOF

if test $BUILD_ONLY -eq 1; then
    exit 0;
fi

if test $DEBIAN -eq 0; then
    TARGET=$SBOX_HOME/$PROJECTFOLDER/snowshoe
    scp $TARGET $N9:$N9HOME
else
    DEBFILE=$(grep -o [-a-z0-9]*_[.0-9a-z-]*_armel\.deb $LOGFILE)
    TARGET=$SBOX_HOME/$DEBFILE
    scp $TARGET $N9:$N9HOME

    stty -echo # do not show the password
    ssh $N9 "devel-su -c \"dpkg -i $N9HOME/$DEBFILE\""
    stty echo
fi

if test $RUN -eq 1 && test $DEBIAN -eq 0; then
    ssh $N9 "DISPLAY=:0 PATH=/opt/qt5/bin:$PATH ./snowshoe --mobile"
fi
