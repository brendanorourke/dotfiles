#!/usr/bin/env bash

git clone --recursive https://github.com/jaagr/polybar $DOTFILES/caches/init/polybar
cd $DOTFLIES/caches/init/polybar

mkdir build && cd build
cmake ..
sudo make install
