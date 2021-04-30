#!/bin/bash -ex

BRANCH=`echo ${GITHUB_REF##*/}`
PROGRAM=PPSSPP

mkdir -p AppDir/usr/bin
cp build/PPSSPPSDL AppDir/usr/bin/
cp -r build/assets/ AppDir/usr/bin/
cp icons/icon-512.svg AppDir/$PROGRAM.svg
cp Qt/PPSSPP.desktop -o AppDir/$PROGRAM.desktop
cp ../ppsspp2/.github/scripts/update.sh -o AppDir/update.sh
cp ../ppsspp2/.github/scripts/AppRun -o AppDir/AppRun
curl -sL https://github.com/AppImage/AppImageKit/releases/download/continuous/AppRun-x86_64 -o AppDir/AppRun-patched
curl -sL https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64 -o ./AppDir/runtime
mkdir -p AppDir/usr/share/applications && cp ./AppDir/$PROGRAM.desktop ./AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons && cp ./AppDir/$PROGRAM.svg ./AppDir/usr/share/icons
mkdir -p AppDir/usr/share/icons/hicolor/scalable/apps && cp ./AppDir/$PROGRAM.svg ./AppDir/usr/share/icons/hicolor/scalable/apps
mkdir -p AppDir/usr/share/pixmaps && cp ./AppDir/$PROGRAM.svg ./AppDir/usr/share/pixmaps
mkdir -p AppDir/usr/share/zenity 
cp /usr/share/zenity/zenity.ui ./AppDir/usr/share/zenity/
cp /usr/bin/zenity ./AppDir/usr/bin/
cp /usr/bin/realpath ./AppDir/usr/bin/


chmod a+x ./AppDir/AppRun
chmod a+x ./AppDir/AppRun-patched
chmod a+x ./AppDir/runtime
chmod a+x ./AppDir/usr/bin/$PROGRAM
chmod a+x ./AppDir/update.sh

cp ../ppsspp2/.github/scripts/update.tar.gz
tar -xzf update.tar.gz
mv update/AppImageUpdate ./AppDir/usr/bin/
mkdir -p AppDir/usr/lib/
mv update/* ./AppDir/usr/lib/

echo $GITHUB_RUN_ID > ./AppDir/version.txt


ls -al ./AppDir

wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod a+x appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage --appimage-extract
squashfs-root/AppRun AppDir/ -u "gh-releases-zsync|qurious-pixel|$PROGRAM|continuous|$PROGRAM-x86_64.AppImage.zsync"
