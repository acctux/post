readonly ICON_DIR="$HOME/.local/share/icons/WhiteSur-grey-dark"

install_whitesur_icons() {
    log INFO "Installing icon theme..."
    local tmp_dir
    tmp_dir="~/icons"
    git clone https://www.github.com/vinceliuice/WhiteSur-icon-theme.git "$tmp_dir"
    (
        cd "$tmp_dir"
        ./install.sh -t grey
    )
    rm -rf "$tmp_dir" "$HOME/.local/share/icons/WhiteSur-grey-light"
    rm -f "$HOME/.local/share/icons/WhiteSur-grey/apps/scalable/preferences-system.svg"
}

change_icon_color() {
    local src_color="#dedede"
    local dst_color="#d3dae3"

    if check_cmd rg sd parallel; then
        log INFO "Replacing icon colors using parallel in batches..."

        rg --files-with-matches "$src_color" "$ICON_DIR" \
            --glob '*.svg' --glob '!*scalable/*' \
        | parallel --pipe --round-robin -j$(nproc) '
            while IFS= read -r file; do
                sd "'"$src_color"'" "'"$dst_color"'" "$file"
            done
        '
    fi
}

install_icons() {
    if [[ ! -d "$ICON_DIR" ]]; then
        install_whitesur_icons

        change_icon_color
        log INFO "Icons installed."
    else
        log INFO "WhiteSur icons already installed. Skipping."
    fi
}
