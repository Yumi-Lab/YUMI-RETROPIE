# YUMI-RETROPIE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-armhf%20%7C%20ARM%20Cortex--A7-orange)](https://github.com/Yumi-Lab/RetroMi)
[![Board](https://img.shields.io/badge/board-SmartPi%20One-green)](https://www.smart-pi.org)
[![Built with RetroMi](https://img.shields.io/badge/built%20with-RetroMi-purple)](https://github.com/Yumi-Lab/RetroMi)
[![Packages](https://img.shields.io/github/v/release/Yumi-Lab/RetroMi-packages?label=packages)](https://github.com/Yumi-Lab/RetroMi-packages/releases/latest)

Fork of [RetroPie/RetroPie-Setup](https://github.com/RetroPie/RetroPie-Setup) maintained by **Yumi Lab** for the [RetroMi](https://github.com/Yumi-Lab/RetroMi) retro gaming OS running on SmartPi One (AllWinner H3).

> **This repo is used as a configuration layer, not for compilation.**
> Emulators are pre-compiled in [RetroMi-packages](https://github.com/Yumi-Lab/RetroMi-packages) and installed as `.tar.gz` archives.

---

## What is YUMI-RETROPIE?

YUMI-RETROPIE is a custom fork of RetroPie-Setup that:

- Removes the `!mali` flag from ports that support software rendering (e.g. OpenBOR), enabling them on Mali-400 GPUs
- Provides `install.sh` — a one-line installer that downloads pre-compiled packages and configures the system
- Is used by the [RetroMi](https://github.com/Yumi-Lab/RetroMi) image builder (CustomPiOS Layer 3) for post-install configuration (`retropie_packages.sh <package> configure`)
- Targets **Debian 12 Bookworm armhf** on AllWinner H3 (Cortex-A7)

---

## Quick Install

On a fresh Debian/Armbian Bookworm system (armhf):

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/YUMI-RETROPIE/main/install.sh | sudo bash
```

Then reboot:

```bash
sudo reboot
```

EmulationStation will start automatically on boot.

> Requires: SmartPi One (AllWinner H3) or compatible armhf board — Debian 12 Bookworm

---

## What gets installed

The installer downloads pre-compiled packages from [RetroMi-packages releases](https://github.com/Yumi-Lab/RetroMi-packages/releases/latest) — no compilation required.

### Supported Emulators

#### Nintendo
| System | Core | Notes |
|--------|------|-------|
| NES | lr-fceumm, lr-nestopia | |
| Super Nintendo | lr-snes9x, lr-snes9x2010 | |
| Game Boy | lr-gambatte, lr-tgbdual | |
| Game Boy Color | lr-gambatte | |
| Game Boy Advance | lr-mgba, lr-gpsp | |
| Nintendo DS | lr-desmume2015 | |
| Nintendo 64 | lr-mupen64plus, lr-parallel-n64 | Heavy — may be slow on H3 |
| PC Engine / TurboGrafx | lr-beetle-pce-fast, lr-geargrafx | |

#### Sega
| System | Core | Notes |
|--------|------|-------|
| Mega Drive / Genesis | lr-genesis-plus-gx, lr-picodrive | |
| Master System | lr-genesis-plus-gx, lr-picodrive | |
| Game Gear | lr-genesis-plus-gx | |
| Sega 32X | lr-picodrive | |
| Sega CD | lr-genesis-plus-gx, lr-picodrive | |
| SG-1000 | lr-genesis-plus-gx | |

#### Sony
| System | Core | Notes |
|--------|------|-------|
| PlayStation 1 | lr-pcsx-rearmed, lr-beetle-psx | |
| PlayStation Portable | lr-ppsspp | Heavy — may be slow on H3 |

#### Arcade
| System | Core | Notes |
|--------|------|-------|
| FBNeo (FinalBurn Neo) | lr-fbneo | Main arcade core |
| MAME 2003-Plus | lr-mame2003-plus | Best compatibility |
| MAME 2003 | lr-mame2003 | |
| MAME 2000 | lr-mame2000 | Lightest |
| MAME 2010 | lr-mame2010 | |
| FBAlpha 2012 | lr-fbalpha2012 | |

#### Portables & Handhelds
| System | Core |
|--------|------|
| Neo Geo Pocket / Color | lr-beetle-ngp |
| Atari Lynx | lr-beetle-lynx |
| Virtual Boy | lr-beetle-vb |
| WonderSwan / Color | lr-beetle-wswan |
| Pokémon Mini | lr-pokemini |
| Mega Duck | lr-sameduck |
| Supervision | lr-potator |
| Uzebox | lr-uzem |
| Arduboy | lr-arduous |

#### Home Computers
| System | Core |
|--------|------|
| Commodore 64 | lr-vice |
| MSX | lr-fmsx |
| Atari 800 / 5200 / 7800 | lr-atari800, lr-prosystem |
| Amstrad CPC | lr-caprice32 |
| ZX Spectrum | lr-fuse |
| Atari ST | lr-hatari |
| Apple II | lr-linapple |
| BBC Micro | lr-beebem |
| Enterprise 128 | lr-ep128emu |

#### Japanese Computers
| System | Core |
|--------|------|
| PC-98 | lr-np2kai |
| PC-88 | lr-quasi88 |
| Sharp X68000 | lr-px68k |
| Sharp X1 | lr-x1 |

#### Amiga
| System | Core |
|--------|------|
| Amiga 500/600/1200 | lr-uae4arm, lr-puae, lr-puae2021 |

#### Heavy Systems
| System | Core | Notes |
|--------|------|-------|
| Nintendo DS | lr-desmume2015 | |
| Sega Dreamcast | lr-flycast | Very heavy on H3 |
| Sega Saturn | lr-yabasanshiro | Very heavy on H3 |
| 3DO | lr-opera | Heavy |
| Atari Jaguar | lr-virtualjaguar | |

#### Ports & Engines
| System | Core / Engine | Notes |
|--------|--------------|-------|
| Doom | lr-prboom | |
| Quake | lr-tyrquake | |
| Cave Story | lr-nxengine | |
| Mr.Boom | lr-mrboom | |
| PICO-8 | lr-fake08 | |
| WASM-4 | lr-wasm4 | |
| EasyRPG | lr-easyrpg | RPG Maker games |
| ONScripter | lr-onscripter | Visual novels |
| FreeJ2ME | lr-freej2me | Java mobile games |
| **OpenBOR** | openbor (standalone) | Beat 'em up engine — DCurrent/openbor, SDL2, no OpenGL |
| ScummVM | lr-scummvm | Point & click adventures |
| DOSBox | lr-dosbox-pure | DOS games |

---

## ROM Structure

Place ROMs in `/home/pi/RetroPie/roms/<system>/`:

```
/home/pi/RetroPie/
├── roms/
│   ├── nes/          → .nes
│   ├── snes/         → .sfc .smc
│   ├── megadrive/    → .md .bin .gen
│   ├── gba/          → .gba
│   ├── n64/          → .z64 .n64 .v64
│   ├── psx/          → .bin+.cue .pbp .chd
│   ├── arcade/       → .zip (FBNeo romset)
│   ├── ports/openbor → game folders with data/
│   └── ...
└── BIOS/
    ├── scph1001.bin  → PlayStation 1
    ├── dc_boot.bin   → Dreamcast
    ├── neogeo.zip    → Neo Geo
    └── gba_bios.bin  → Game Boy Advance
```

---

## Differences from upstream RetroPie-Setup

| Change | Description |
|--------|-------------|
| `scriptmodules/ports/openbor.sh` | Source → DCurrent/openbor (CMake, SDL2). Removed `!mali` flag — `USE_OPENGL=OFF` makes it compatible with Mali-400 |
| `install.sh` | Rewritten — downloads pre-compiled packages from RetroMi-packages, no inline compilation |

---

## Related Repositories

| Repo | Role |
|------|------|
| [Yumi-Lab/RetroMi](https://github.com/Yumi-Lab/RetroMi) | RetroMi OS image builder (CustomPiOS) |
| [Yumi-Lab/RetroMi-packages](https://github.com/Yumi-Lab/RetroMi-packages) | Pre-compiled emulator packages (19 groups, QEMU Docker) |
| [Yumi-Lab/SmartPi-armbian](https://github.com/Yumi-Lab/SmartPi-armbian) | Armbian base image for SmartPi One |
| [Yumi-Lab/auto-mount-retromi](https://github.com/Yumi-Lab/auto-mount-retromi) | USB auto-mount service (plug & play ROMs) |

---

## TODO

- [ ] **OpenBOR** — validate QEMU build (DCurrent/openbor CMake) — `packages-openbor-armhf.tar.gz` in next release
- [ ] **RetroArch binary** — add to RetroMi-packages (currently compiled inline ~40min) — route to `yumi-fr` native runner
- [ ] **arm64 support** — SmartPi 4 (H618, Mali-G31) — separate package build with `arm64` arch
- [ ] **Sinden Lightgun** — `scriptmodules/supplementary/sinden.sh` — module currently broken
- [ ] **ScummVM standalone** — supplement lr-scummvm with native ScummVM for better compatibility
- [ ] **ScummVM build time** — ~33h in QEMU armhf — explore native H3 runner (like EmulationStation)

---

## License

GPL v3 — see [LICENSE.md](LICENSE.md)

Based on [RetroPie/RetroPie-Setup](https://github.com/RetroPie/RetroPie-Setup) © The RetroPie Project
