#!/bin/env bash
set -e

if [[ "$(uname)" == "Darwin" ]]; then
    # at least for Travis's compiler, -O2 fails the unit tests
    export CXXFLAGS="${CXXFLAGS} -O1"
else
    export CXXFLAGS="${CXXFLAGS} -O2"
fi
export CXXFLAGS="${CXXFLAGS} -DNDEBUG"


function build() {
    suffix=$1
    extra_args=$2

    mkdir build-$suffix
    cd build-$suffix
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DCMAKE_PREFIX_PATH="$PREFIX" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DHAVE_LIBZ=FALSE -DHAVE_LIBLZO2=FALSE \
        $extra_args

    make -j $CPU_COUNT

    # need to be in the root directory for this to run properly
    cd ..
    build-$suffix/snappy_unittest
    cd build-$suffix

    make install

    cd ..
}


build dynamic "-DBUILD_SHARED_LIBS=ON"
