#!/usr/bin/env bash
[ -f .bashrc ] && . .bashrc
set -ev
INSTALL_DIR="${1:-/opt}"
# SIRF
git clone https://github.com/SyneRBI/SIRF-SuperBuild --recursive -b master $INSTALL_DIR/SIRF-SuperBuild
pushd $INSTALL_DIR/SIRF-SuperBuild

COMPILER_FLAGS="-DCMAKE_C_COMPILER='$(which gcc)' -DCMAKE_CXX_COMPILER='$(which g++)'"
echo $PATH
echo $COMPILER_FLAGS
echo $BUILD_FLAGS $EXTRA_BUILD_FLAGS
cmake $BUILD_FLAGS $EXTRA_BUILD_FLAGS $COMPILER_FLAGS .

cmake --build . -j 2

if [ ! $? -eq '0' ]
then 
  cmake --build . -j 2
fi

popd
