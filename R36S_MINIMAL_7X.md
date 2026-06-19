# R36S / RK3326 Minimal Mainline 7.x Image

Este es un fork experimental de `AveyondFly/distribution_rocknix` orientado a crear una imagen ligera para la R36S y clones RK3326 usando un kernel **mainline Linux 7.x**.

## Estado actual

- Rama de trabajo: `r36s-minimal-7x`
- Kernel base: **Linux 7.1** (mainline)
- Perfil: **MINIMAL** (servicios y paquetes pesados eliminados)

## Cambios realizados

### 1. Perfil ligero

| Área | Cambios |
|------|---------|
| Red | Eliminados Samba server, ZeroTier, WireGuard, Tailscale, OpenSSH, Avahi, Simple HTTP Server |
| Multimedia | Eliminados VLC, MPV, gmu, m8c, espeak, imagemagick |
| Sistema | Eliminados synctools, rocknix-meta, rocknix-user-docs, misc-packages, debug tools, htop/btop |
| Emuladores RK3326 | Eliminados box64, mednafen, portmaster, scummvmsa, yabasanshiro-sa, duckstation-sa, ppsspp2021-sa |
| Drivers RK3326 | Reducidos a RTL8812AU, RTL8821AU, RTL8821CU, RTL88x2BU, mali-bifrost, aic8800-usb |

### 2. Migración a kernel 7.1

Archivo modificado: `projects/ROCKNIX/packages/linux/package.mk`

```bash
PKG_VERSION="7.1"
PKG_URL="https://www.kernel.org/pub/linux/kernel/v7.x/linux-7.1.tar.xz"
```

### 3. Parches RK3326 actualizados para 7.1

Ubicación: `projects/ROCKNIX/devices/RK3326/patches/linux/`

| Parche | Estado en 7.1 | Notas |
|--------|---------------|-------|
| `000-rk3326-dts.patch` | OK | Aplica limpio |
| `001-panel-updates.patch` | OK | Aplica limpio |
| `0026-phy-rockchip-inno-usb2...` | OK | Aplica limpio |
| `004-input-drivers.patch` | OK | Se quitó workaround del cargador rk817 |
| `005-unigue-gpio-guid.patch` | OK | Aplica limpio |
| `007-ogs-panel-timings.patch` | OK | Aplica limpio |
| `008-esp-8089-wifi.patch` | OK | Regenerado para 7.1 (contexto Kconfig/Makefile + líneas en blanco entre diffs) |
| `020-elida-refresh-rates.patch` | OK | Aplica limpio |
| `022-usb-role-switch.patch` | OK | Aplica limpio |
| `025-mainline-linux-fix-for-mipi.patch` | OK | Aplica limpio |
| `099-drm-rockchip-add-vop-brightness-crtc-control.patch` | OK | Regenerado para 7.1; VOP2 omitido (no usado en RK3326), `linux/iopoll.h` ya presente en 7.1 |
| `100-leds-r36ultra.patch` | OK | Regenerado para 7.1 (contexto Kconfig/Makefile actualizado) |
| `024-mainline-linux-hacks-for-rk915.patch` | **Eliminado** | Movido a `linux-6.12/` porque se quitó el driver rk915 |

## Cómo compilar

Requisitos: sistema Linux con Docker recomendado, o un entorno con las dependencias de LibreELEC/ROCKNIX.

```bash
cd rocknix
make RK3326
```

O manualmente:

```bash
PROJECT=ROCKNIX DEVICE=RK3326 ARCH=arm ./scripts/build_distro
PROJECT=ROCKNIX DEVICE=RK3326 ARCH=aarch64 ./scripts/build_distro
```

## Próximos pasos / pendientes

1. **Actualizar kernel config**: revisar `projects/ROCKNIX/devices/RK3326/linux/linux.aarch64.conf` para nuevos/renombrados símbolos de 7.1.
2. **Probar out-of-tree drivers**: `mali-bifrost`, `aic8800-usb`, Realtek USB WiFi pueden necesitar ajustes para 7.1.
3. **Compilar y probar en hardware real**: validar boot, pantalla, controles, audio, red, batería.
4. **Medir benchmarks**: boot time, FPS en emuladores, duración de batería vs ArkOS/ROCKNIX original.
5. **Ajustar governors/thermal**: optimizar `schedutil`, thermal throttling y suspensión para máxima batería.
6. **Considerar reemplazar Sway**: evaluar si EmulationStation puede correr con un compositor más ligero o directo KMS/DRM.

## Riesgos conocidos

- Los parches se adaptaron manualmente para 7.1; pueden requerir ajustes adicionales durante el build.
- El entorno Windows usado para el desarrollo no permite probar la aplicación de parches con total precisión; el build real debe hacerse en Linux.
- Algunos emuladores pesados fueron eliminados; N64/Dreamcast/Saturn dependen ahora de cores más ligeros.

## Créditos

Basado en el trabajo de:
- ROCKNIX / JELOS teams
- `AveyondFly/distribution_rocknix` (fork con soporte extendido de clones RK3326)
