# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="glew"
PKG_VERSION="2.2.0"
PKG_LICENSE="BSD"
PKG_SITE="http://glew.sourceforge.net/"
PKG_URL="${SOURCEFORGE_SRC}/glew/glew/${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="GLEW - The OpenGL Extension Wrangler Library"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

if [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_DEPENDS_TARGET+=" wayland ${WINDOWMANAGER} xwayland xrandr libXi libX11"
  PKG_CMAKE_OPTS_TARGET+=" -DGLEW_X11=ON"
fi

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
fi

pre_configure() {
  PKG_CMAKE_SCRIPT=${PKG_BUILD}/build/cmake/CMakeLists.txt
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+="      -DBUILD_UTILS=OFF \n				-DGLEW_REGAL=OFF \n				-DGLEW_OSMESA=OFF \n				-DGLEW_EGL=ON \n				-DBUILD_SHARED_LIBS=ON"

  if [ ! "${DISPLAYSERVER}" = "x11" ] && [ ! "${DISPLAYSERVER}" = "wl" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DOPENGL_USE_EGL=TRUE -DGLEW_X11=OFF"
  fi
}
