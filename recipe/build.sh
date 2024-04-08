#!/bin/env bash
set -e

if [[ "$(uname)" == "Darwin" ]]; then
    # at least for Travis's compiler, -O2 fails the unit tests
    export CXXFLAGS="${CXXFLAGS} -O1"
    export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_STANDARD=14"
else
    export CXXFLAGS="${CXXFLAGS} -O2"
fi
export CXXFLAGS="${CXXFLAGS} -DNDEBUG"


function build() {
    suffix=$1
    extra_args=$2

    mkdir build-$suffix
    cd build-$suffix
    cmake ${CMAKE_ARGS} .. \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DCMAKE_PREFIX_PATH="$PREFIX" \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DHAVE_LIBZ=FALSE -DHAVE_LIBLZO2=FALSE \
	-DSNAPPY_BUILD_BENCHMARKS=OFF \
        -DSNAPPY_ENABLE_RTTI=ON \
        $extra_args

    make -j $CPU_COUNT

    # need to be in the root directory for this to run properly
    if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
        cd ..
        build-$suffix/snappy_unittest
        cd build-$suffix
    fi

    make install

    cd ..
}


build dynamic "-DBUILD_SHARED_LIBS=ON"
