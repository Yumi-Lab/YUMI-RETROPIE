#!/usr/bin/env bash
# YUMI-RETROPIE — Installer
# Installs RetroMi (RetroPie + EmulationStation) from pre-compiled packages.
# Compatible: Debian 12 Bookworm, armhf (SmartPi One / H3)
#
# Usage: curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/YUMI-RETROPIE/main/install.sh | sudo bash

set -e

PACKAGES_URL="https://github.com/Yumi-Lab/RetroMi-packages/releases/latest/download"
RETROPI_DIR="/home/pi/RetroPie"
RETROPIE_SETUP_DIR="/home/pi/RetroPie-Setup"
BASE_USER="pi"

# Colors
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[RetroMi]${NC} $*"; }
warn() { echo -e "${RED}[WARN]${NC} $*"; }

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run as root: sudo bash install.sh"
    exit 1
fi

log "=== YUMI-RETROPIE Installer ==="
log "Target user: ${BASE_USER}"

# Runtime dependencies
log "Installing runtime dependencies..."
apt-get update -qq
apt-get install -y --no-install-recommends \
    wget ca-certificates dialog xmlstarlet git \
    wireless-tools wpasupplicant network-manager \
    libfreeimage3 \
    libsdl2-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0 \
    libvlc5 \
    joystick

# Download and extract pre-compiled package groups
log "Downloading pre-compiled packages..."
mkdir -p /opt/retropie

GROUPS="retroarch arcade arcade-compat nintendo n64 sega sony psp misc openbor scummvm dosbox portables computers amiga japan-computers heavy emulationstation"

for group in ${GROUPS}; do
    url="${PACKAGES_URL}/packages-${group}-armhf.tar.gz"
    log "  → ${group}"
    if wget -q --show-progress --tries=3 --timeout=60 \
        -O "/tmp/packages-${group}-armhf.tar.gz" "${url}"; then
        tar -xzf "/tmp/packages-${group}-armhf.tar.gz" -C /
        rm -f "/tmp/packages-${group}-armhf.tar.gz"
    else
        warn "packages-${group}-armhf.tar.gz not available — skipping"
        rm -f "/tmp/packages-${group}-armhf.tar.gz"
    fi
done

# Clone YUMI-RETROPIE for post-install configuration
log "Cloning YUMI-RETROPIE..."
if [ -d "${RETROPIE_SETUP_DIR}/.git" ]; then
    git -C "${RETROPIE_SETUP_DIR}" pull --ff-only
else
    git clone --depth=1 -b main \
        https://github.com/Yumi-Lab/YUMI-RETROPIE.git \
        "${RETROPIE_SETUP_DIR}"
fi
chown -R "${BASE_USER}:${BASE_USER}" "${RETROPIE_SETUP_DIR}"

export __platform="armv7-mali"
export __user="${BASE_USER}"

cd "${RETROPIE_SETUP_DIR}"

# Post-install configuration
log "Configuring RetroPie services..."
bash retropie_packages.sh runcommand
bash retropie_packages.sh bluetooth depends
bash retropie_packages.sh usbromservice || true

# Configure EmulationStation FIRST (generates per-system retroarch.cfg)
log "Configuring EmulationStation..."
bash retropie_packages.sh emulationstation configure || true
bash retropie_packages.sh retropiemenu configure || true

# Register all installed libretro cores
log "Registering emulators..."
for core_dir in /opt/retropie/libretrocores/lr-*/; do
    [ -d "${core_dir}" ] || continue
    core_name=$(basename "${core_dir}")
    bash retropie_packages.sh "${core_name}" configure || true
done

# Register standalone ports
for port in openbor; do
    if [ -d "/opt/retropie/ports/${port}" ]; then
        log "  → ${port} (port)"
        bash retropie_packages.sh "${port}" configure || true
    fi
done

log "Setting up autostart..."
bash autostartES.sh

# Create ROM directories
log "Creating ROM directories..."
ROM_DIR="${RETROPI_DIR}/roms"
mkdir -p "${ROM_DIR}"
for sys in \
    nes snes megadrive mastersystem gamegear genesis sega32x segacd sg-1000 \
    gb gbc gba nds n64 psx psp \
    atari2600 atari5200 atari7800 atarilynx atarist \
    pcengine ngp ngpc wonderswan wonderswancolor \
    mame-libretro fba arcade neogeo \
    scummvm dosbox c64 msx zxspectrum amstradcpc amiga \
    dreamcast saturn 3do jaguar vectrex coleco intellivision \
    ports/openbor; do
    mkdir -p "${ROM_DIR}/${sys}"
done
chown -R "${BASE_USER}:${BASE_USER}" "${RETROPI_DIR}"

# Fix paths in es_systems.cfg
ES_CFG="/etc/emulationstation/es_systems.cfg"
if [ -f "${ES_CFG}" ]; then
    sed -i "s|/home/runner/RetroPie|/home/${BASE_USER}/RetroPie|g;
            s|/root/RetroPie|/home/${BASE_USER}/RetroPie|g" "${ES_CFG}"
fi

# sudoers — allow pi to run RetroPie scripts without password
SUDOERS_FILE="/etc/sudoers.d/retromi-nopasswd"
cat > "${SUDOERS_FILE}" << 'EOF'
pi ALL=(ALL) NOPASSWD: /usr/sbin/armbian-config
pi ALL=(ALL) NOPASSWD: /usr/sbin/nmcli
pi ALL=(ALL) NOPASSWD: /home/pi/RetroPie-Setup/retropie_packages.sh
EOF
chmod 440 "${SUDOERS_FILE}"

chown -R "${BASE_USER}:${BASE_USER}" /opt/retropie/configs 2>/dev/null || true

log "=== Installation complete ==="
log "Reboot to start EmulationStation: sudo reboot"
