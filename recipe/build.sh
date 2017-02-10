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
if [ "$(uname)" == "Linux" ]; then
  export CXXFLAGS="${CXXFLAGS} -O2 -DNDEBUG"
else
  # There is at least on OSX a bug affecting -O2 builds
  export CXXFLAGS="${CXXFLAGS} -O1 -DNDEBUG"
fi

./configure --with-pic --prefix=$PREFIX --disable-dependency-tracking
make
make check
make install
