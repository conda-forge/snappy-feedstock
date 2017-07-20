#!/bin/env bash
set -e

mkdir build
cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DCMAKE_BUILD_TYPE=Release

make -j $CPU_COUNT

# need to be in the root directory for this to run properly
cd ..
build/snappy-unittest
cd build

make install
