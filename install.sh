#!/bin/bash

basedir=$PWD/$PKG/bin
target=$(cat /etc/issue | awk '/Ubuntu/{print $2}' | sed 's/\.[0-9]$//g')

if ! which $PKG > /dev/null; then
  mkdir -p $basedir/$target/lib
  {
    cd $basedir/$target/lib
    sudo apt-get install -y $DEPS
    cp $(which $PKG) ..
    libs=$(ldd $(which $PKG) | sed 's/ (.*$//g' | sed 's/^.*=> //g' | tr -d ' ' | awk '/^\/.*\.so/{print $1}')

    for file in ${libs[@]}; do
      cp $file .
    done
  }
fi
