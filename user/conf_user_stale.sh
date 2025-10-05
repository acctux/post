# ------ User Configuration ------
ROOT_LABEL="Arch"
ICON_REPO="https://www.github.com/vinceliuice/WhiteSur-icon-theme.git"
ETC_DOTS_DIR="/home/nick/Lit/dotfiles/etc"
DIFFS_DIR="$HOME/dotcetera"
CHAOTIC_KEY_FILE="$HOME/Lit/dotfiles/chaotic.gpg"

# --------- Keys -----------
GPG_KEYFILE="$NEW_KEY_DIR/my-private-key.asc"
SSH_KEY="$NEW_KEY_DIR/id_ed25519"

# --------- Git -----------
GIT_USER="acctux"
GIT_DIR="$HOME/Lit"
DOTFILES_DIR="$GIT_DIR/dotfiles"
BACKUP_DIR="$HOME/overwrittendots"
GIT_REPOS=(
    "docs"
    "dotfiles"
    "fresh"
    "freshpy"
    "post"
)

# Items for Removal
CLEANUP_SUDO_ITEMS=(
    /usr/share/icons/capitaine-cursors
)

CLEANUP_USER_ITEMS=(
    "$HOME/.cargo/paru"
    "$HOME/.keychain"
    "$HOME/.parallel"
    "$HOME/.nv"
)
