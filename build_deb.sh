#!/bin/bash
# Builds the genarts-tuttle deb file

usage()
{
cat <<EOF
usage: $0 options
EOF
}

VERSION='0.0'
REVISION='0'
ARCH='amd64'

ARGS=$(getopt -o v:r:a: -l "version:,revision:,arch:" -- "$@")

if [[ $? -ne 0 ]]; then usage; exit 1; fi

eval set -- "$ARGS";

set -x

while true; do
    case "$1" in
	-v|--version)
	    VERSION="$2"
	    shift 2 ;;
	-r|--revision)
	    REVISION="$2"
	    shift 2 ;;
	-a|--arch)
	    ARCH="$2"
	    shift 2 ;;
	--)
	    shift
	    break
	    ;;
	*) echo "Invalid arg!"
	    exit 1 ;;
    esac
done

GENARTS_TUTTLE=genarts-tuttle_"$VERSION"-"$REVISION"_"$ARCH"
echo $GENARTS_TUTTLE

# Remove old files
if [ -d $GENARTS_TUTTLE ]; then
    rm -rf $GENARTS_TUTTLE
fi

if [ -f $GENARTS_TUTTLE.deb ]; then
    rm $GENARTS_TUTTLE.deb
fi

# Build directory structure
mkdir $GENARTS_TUTTLE
mkdir $GENARTS_TUTTLE/DEBIAN
mkdir $GENARTS_TUTTLE/etc
mkdir $GENARTS_TUTTLE/etc/ld.so.conf.d
mkdir $GENARTS_TUTTLE/usr
mkdir $GENARTS_TUTTLE/usr/bin
mkdir $GENARTS_TUTTLE/usr/lib
mkdir $GENARTS_TUTTLE/usr/lib/GenArts
mkdir $GENARTS_TUTTLE/usr/lib/python2.7
mkdir $GENARTS_TUTTLE/usr/lib/python2.7/dist-packages
mkdir $GENARTS_TUTTLE/usr/OFX
mkdir $GENARTS_TUTTLE/usr/OFX/Plugins

# Copy control file
cp ./control ./$GENARTS_TUTTLE/DEBIAN

# Edit Control file for correct version, revision, and arch
sed -i s/__VERSION__/"$VERSION"/g ./$GENARTS_TUTTLE/DEBIAN/control
sed -i s/__REVISION__/"$REVISION"/g ./$GENARTS_TUTTLE/DEBIAN/control
sed -i s/__ARCH__/"$ARCH"/g ./$GENARTS_TUTTLE/DEBIAN/control

# Copy postinst file
cp ./postinst ./$GENARTS_TUTTLE/DEBIAN

# Copy postrm file
cp ./postrm ./$GENARTS_TUTTLE/DEBIAN

# Copy conf file
cp ./genarts-tuttle.conf ./$GENARTS_TUTTLE/etc/ld.so.conf.d

# Copy shared Libraries
cp ../TuttleOFX/3rdParty/lib/* ./$GENARTS_TUTTLE/usr/lib/GenArts

# Copy binaries
cp /home/ubuntu/bin/ffmpeg ./$GENARTS_TUTTLE/usr/bin
cp /home/ubuntu/bin/ffprobe ./$GENARTS_TUTTLE/usr/bin
cp /home/ubuntu/bin/ffserver ./$GENARTS_TUTTLE/usr/bin
cp /home/ubuntu/bin/qt-faststart ./$GENARTS_TUTTLE/usr/bin
cp ../TuttleOFX/dist/ip-10-0-3-180/gcc-4.6/production/bin/* ./$GENARTS_TUTTLE/usr/bin

# Copy Python
cp -r ../TuttleOFX/dist/ip-10-0-3-180/gcc-4.6/production/python/* ./$GENARTS_TUTTLE/usr/lib/python2.7/dist-packages

# Copy Plugins
cp -r ../TuttleOFX/dist/ip-10-0-3-180/gcc-4.6/production/plugin/* ./$GENARTS_TUTTLE/usr/OFX/Plugins

# Build deb file as fakeroot
fakeroot dpkg-deb --build $GENARTS_TUTTLE
