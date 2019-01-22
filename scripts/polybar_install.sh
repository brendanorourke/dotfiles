#!/usr/bin/env bash

mkdir -p $DOTFILES/caches/init
git clone --recursive https://github.com/jaagr/polybar $DOTFILES/caches/init/polybar
cd $DOTFLIES/caches/init/polybar

rm -rf build
mkdir build && cd build

cmake ..
sudo make install
