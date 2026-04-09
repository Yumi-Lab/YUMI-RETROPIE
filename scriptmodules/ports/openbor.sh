#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openbor"
rp_module_desc="OpenBOR - Beat 'em Up Game Engine"
rp_module_help="Place your OpenBOR game folders in $romdir/ports/openbor. Each game should be a folder containing its data/ directory."
rp_module_licence="BSD https://raw.githubusercontent.com/DCurrent/openbor/master/LICENSE"
rp_module_repo="git https://github.com/DCurrent/openbor.git master"
rp_module_section="exp"
rp_module_flags="!x11"

function depends_openbor() {
    getDepends cmake libsdl2-dev libogg-dev libvorbis-dev libpng-dev zlib1g-dev
}

function sources_openbor() {
    gitPullOrClone
}

function build_openbor() {
    # linux.cmake uses set() (local var) which overrides cmake -D cache flags.
    # Patch directly to disable OpenGL and WebM for Mali-400 / embedded targets.
    sed -i \
        -e 's/set(USE_OPENGL\s*ON)/set(USE_OPENGL OFF)/' \
        -e 's/set(USE_LOADGL\s*ON)/set(USE_LOADGL OFF)/' \
        -e 's/set(USE_WEBM\s*ON)/set(USE_WEBM OFF)/' \
        cmake/linux.cmake

    rm -rf build
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_LINUX=ON
    make -j"$(nproc)"
    md_ret_require="$md_build/engine/releases/LINUX/OpenBOR"
}

function install_openbor() {
    md_ret_files=(
       'engine/releases/LINUX/OpenBOR'
    )
}

function configure_openbor() {
    addPort "$md_id" "openbor" "OpenBOR - Beats of Rage Engine" "$md_inst/openbor.sh"

    mkRomDir "ports/$md_id"

    cat >"$md_inst/openbor.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
./OpenBOR "\$@"
popd
_EOF_
    chmod +x "$md_inst/openbor.sh"

    local dir
    for dir in ScreenShots Logs Saves; do
        mkUserDir "$md_conf_root/$md_id/$dir"
        ln -snf "$md_conf_root/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/ports/$md_id" "$md_inst/Paks"
}
