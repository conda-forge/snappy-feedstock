#!/bin/env bash

./autogen.sh
./configure --with-pic --prefix=$PREFIX
make
make check
make install
