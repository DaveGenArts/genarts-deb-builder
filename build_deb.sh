#!/bin/bash
# Builds the genarts-tuttle deb file

# Remove old files
if [ -d genarts-tuttle ]; then
    rm -rf genarts-tuttle
fi

if [ -f genarts-tuttle.deb ]; then
    rm genarts-tuttle.deb
fi

# Build directory structure
mkdir genarts-tuttle
mkdir genarts-tuttle/DEBIAN
mkdir genarts-tuttle/etc
mkdir genarts-tuttle/etc/ld.so.conf.d
mkdir genarts-tuttle/usr
mkdir genarts-tuttle/usr/bin
mkdir genarts-tuttle/usr/lib
mkdir genarts-tuttle/usr/lib/GenArts
mkdir genarts-tuttle/usr/lib/python2.7
mkdir genarts-tuttle/usr/lib/python2.7/dist-packages
mkdir genarts-tuttle/usr/OFX
mkdir genarts-tuttle/usr/OFX/Plugins

# Copy control file
cp ./control ./genarts-tuttle/DEBIAN

# Copy postinst file
cp ./postinst ./genarts-tuttle/DEBIAN

# Copy postrm file
cp ./postrm ./genarts-tuttle/DEBIAN

# Copy conf file
cp ./genarts-tuttle.conf ./genarts-tuttle/etc/ld.so.conf.d

# Copy shared Libraries
cp ../TuttleOFX/3rdParty/lib/* ./genarts-tuttle/usr/lib/GenArts

# Copy binaries
cp /home/build/bin/* ./genarts-tuttle/usr/bin
cp ../TuttleOFX/dist/ubuntu/gcc-4.6/production/bin/* ./genarts-tuttle/usr/bin

# Copy Python
cp -r ../TuttleOFX/dist/ubuntu/gcc-4.6/production/python/* ./genarts-tuttle/usr/lib/python2.7/dist-packages

# Copy Plugins
cp -r ../TuttleOFX/dist/ubuntu/gcc-4.6/production/plugin/* ./genarts-tuttle/usr/OFX/Plugins

# Build deb file as fakeroot
fakeroot dpkg-deb --build genarts-tuttle
