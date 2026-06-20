# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/addons/addon-depends/chrome-depends/gtk3/package.mk

PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango libxkbcommon wayland wayland-protocols libepoxy libpng tiff libjpeg-turbo libffi glew"

unset PKG_BUILD_FLAGS

if [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_MESON_OPTS_TARGET="${PKG_MESON_OPTS_TARGET/-Dwayland_backend=false/-Dwayland_backend=true}"
fi
if [ "${DISPLAYSERVER}" != "x11" ]; then
  PKG_MESON_OPTS_TARGET="${PKG_MESON_OPTS_TARGET/-Dx11_backend=true/-Dx11_backend=false}"
fi

post_makeinstall_target() {
  ${TOOLCHAIN}/bin/glib-compile-schemas ${INSTALL}/usr/share/glib-2.0/schemas
}
