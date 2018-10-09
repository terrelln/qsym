#!/bin/bash -e

git submodule init
git submodule update

# install system deps
sudo yum install gcc-4.8.5 llvm-devel

# Use gcc-4.8.5
GCC=/bin/gcc
GXX=/bin/g++
$GCC --version
$GXX --version

# install z3
pushd third_party/z3
if [ -d build ]; then
  rm -rf build
fi
CC=$GCC CXX=$GXX ./configure
cd build
CC=$GCC CXX=$GXX make -j$(nproc)
CC=$GCC CXX=$GXX sudo make install
popd

# Create the virtual environment

VENV=$HOME/virtualenvs/qsym-py2
if [ ! -d "$VENV" ]; then
  pyenv virtualenv --version 'platform007/2.7.14' qsym-py2
fi
PIP="$VENV/bin/pip"
CC=$GCC CXX=$GXX "$PIP" install .

cat <<EOM
QSYM is installed to the virtual environment $VENV.
Source the virtual environment to use QSYM.

  $ source $VENV/bin/activate
EOM
