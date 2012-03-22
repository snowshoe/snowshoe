#!/bin/sh


SBOX_HOME=/scratchbox/users/$USER/home/$USER
PROJECTFOLDER_HOST=$(pwd -P)
PROJECTFOLDER=$(basename $PROJECTFOLDER_HOST)-tmp

# N9 configuration. This is the default ip for USB connections.
N9=developer@192.168.2.15
N9HOME=/home/developer

echo "rsync $PROJECTFOLDER_HOST to $SBOX_HOME/$PROJECTFOLDER"
rsync -azrptL --progress --exclude-from=".gitignore" --exclude ".git" $PROJECTFOLDER_HOST/ $SBOX_HOME/$PROJECTFOLDER

# Build project
scratchbox -s <<EOF
cd $PROJECTFOLDER
export PATH=/opt/qt5/bin:\$PATH
make distclean
qmake
make -j 3
EOF

scp $SBOX_HOME/$PROJECTFOLDER/snowshoe $N9:$N9HOME
