#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q fs-uae | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/FrodeSolheim/fs-uae-launcher/refs/heads/main/share/icons/hicolor/256x256/apps/fs-uae-launcher.png
export DESKTOP=https://raw.githubusercontent.com/FrodeSolheim/fs-uae-launcher/refs/heads/main/share/applications/fs-uae-launcher.desktop
export STARTUPWMCLASS=fs-uae-launcher
export DEPLOY_OPENGL=1
export DEPLOY_PYTHON=1

# Deploy dependencies
mkdir -p ./AppDir/bin
cp -r /usr/share/fs-uae-launcher/* ./AppDir/bin
quick-sharun ./AppDir/bin/* /usr/bin/fs-uae /usr/bin/fs-uae-device-helper /usr/lib/libopenal.so* /usr/lib/libQt6Gui.so*
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
