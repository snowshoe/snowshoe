#!/bin/sh

MIRROR_URL=http://qtlabs.org.br/~lmoura/qt5/

# Uncomment line below to use the internal mirror
#MIRROR_URL=http://10.60.5.99/lauro/qt5/

scratchbox -s <<EOF
echo "deb $MIRROR_URL unstable main" >> /etc/apt/sources.list
apt-get update
fakeroot apt-get install -y "qt5-*" webkit-snapshot qt-components2
EOF
