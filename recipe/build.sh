#!/bin/env bash


# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
#
source activate "${CONDA_DEFAULT_ENV}"

autoreconf --force --install
./autogen.sh
CXXFLAGS="${CXXFLAGS} -O1 -DNDEBUG" ./configure --with-pic --prefix=$PREFIX --disable-dependency-tracking
make
make check
make install
