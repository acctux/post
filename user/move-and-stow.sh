generate_target_list() {
  fd --type f --hidden --exclude .git . "$GIT_DIR/dotfiles" | sed "s|^$GIT_DIR/dotfiles/|$HOME/|" >/tmp/dotfiles-targets.txt
}

remove_conflicts() {
  while read -r target; do
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm "$target"
    fi
  done </tmp/dotfiles-targets.txt
}

stow_dotfiles() {
  echo "[INFO] Stowing dotfiles..."
  if stow --no-folding -d "$GIT_DIR" -t "$HOME" dotfiles; then
    echo "[INFO] Stow succeeded."
  else
    echo "[ERROR] Stow failed."
    return 1
  fi
}

gtk_symlinks() {
  log INFO "Creating GTK theme symlinks..."
  local gtk_config_dir="$HOME/.config/gtk-4.0"
  mkdir -p "$gtk_config_dir"
  ln -sf "$HOME/.themes/Sweet-Ambar-Blue-Dark/gtk-4.0/gtk.css" "$gtk_config_dir/gtk.css"
  ln -sf "$HOME/.themes/Sweet-Ambar-Blue-Dark/gtk-4.0/gtk-dark.css" "$gtk_config_dir/gtk-dark.css"
}

move_and_stow() {
  echo "[INFO] Generating target file list..."
  generate_target_list
  remove_conflicts
  stow_dotfiles
  gtk_symlinks
}
