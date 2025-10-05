
# Export system units array (run once at script startup)
system_units_array() {
  mapfile -t SYSTEM_UNITS < <(systemctl list-unit-files --type=service,timer,socket --no-legend | awk '{print $1}')
  export SYSTEM_UNITS
}

enable_user_services() {
  log INFO "Enabling system units..."
  for unit in "${SERV_ENABLE[@]}"; do
    if [[ " ${SYSTEM_UNITS[*]} " =~ " ${unit} " ]]; then
      systemctl --user enable "$unit"
    else
      log WARNING "Unit $unit not found"
    fi
  done
}

# .ssh/config
Host *
    # Use GNOME Keyring's SSH agent for key management
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519

    # Multiplexing setup for efficient connections
    ControlPath ~/.ssh/cm-%r@%h:%p.sock
    ControlMaster auto
    ControlPersist 30m

    # Additional settings for reliability
    ServerAliveInterval 120
    ServerAliveCountMax 3
dingo() {
    configure_users
    sudoers_permissions
}
