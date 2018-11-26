#!/bin/bash

# run the configure script in the current directory
# with proper settings to build the executables we want
# on servers that we do not have admin privileges for

# NOTE: This is not a panacea; projects may use other build systems, e.g.
#       plain makefiles, cmake, etc...
#       However, it still provides useful documentation about compiler options.

# load path definition for local builds
. "$HOME/.config/meta/set-local-buildpath"

# setup basic variables
BUILD_ROOT="$HOME/.config/local/build"
INSTALL_ROOT="$BUILD_ROOT/local"
LINKER_PATH="$BUILD_ROOT/lib/libc.so"

# setup flag variables
DYNLINK="-Wl,--dynamic-linker=$LINKER_PATH"
LOCAL_LIB="-L$INSTALL_ROOT/lib"

# set program flags/paths
CFLAGS="$DYNLINK $LOCAL_LIB $CFLAGS"
CXXFLAGS="$DYNLINK $LOCAL_LIB $CXXFLAGS"
LDFLAGS="$DYNLINK $LOCAL_LIB $LDFLAGS"

export PKG_CONFIG_LIBDIR="$INSTALL_ROOT/lib/pkgconfig"

export CMAKE_EXTRA_FLAGS="-DCFLAGS='$DYNLINK' -DCXXFLAGS='$DYNLINK' -DLDFLAGS='$DYNLINK' -DCMAKE_INSTALL_PREFIX='$INSTALL_ROOT' -DENABLE_JEMALLOC=OFF"
export DEPS_CMAKE_FLAGS="-DCFLAGS='$CFLAGS' -DCXXFLAGS='$CXXFLAGS' -DLDFLAGS='$DYNLINK' -DUSE_BUNDLED_JEMALLOC=OFF"

export VERBOSE=1

# run build script
make
