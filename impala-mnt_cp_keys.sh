#-------------------------------------------------------------------------
#                    Automated Arch Linux Installer
#-------------------------------------------------------------------------
DEVICE=""
CHOICE=""
KEYS_MNT="/mnt/keys"
KEY_FILES=(
    id_ed25519
    id_ed25519.pub
    my_public_key.asc
    my_private_key.asc
)
make_choice() {
    while true; do
        echo "Detecting available PARTITIONS..."

        # Reset PARTITIONS=()
        local -a PARTITIONS=()
        local index=1

        while read -r line; do
            # Parse using eval
            eval "$line"

            # Check if it's an unmounted partition
            if [[ "$TYPE" == "part" && -z "$MOUNTPOINT" ]]; then
                local dev="/dev/$NAME"
                PARTITIONS+=("$dev")

                local mount_status="UNMOUNTED"

                printf "%d) %-10s Size: %-6s FS: %-6s Mounted: %-12s Removable: %s\n" \
                    "$index" "$dev" "$SIZE" "$FSTYPE" "$mount_status" "$RM"

                ((index++))
            fi
        done < <(lsblk -P -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT,RM)

        if [[ ${#PARTITIONS[@]} -gt 0 ]]; then
            break  # Partitions found, exit loop
        fi

        echo "No partitions detected. Please insert your device and press Enter to retry..."
        read -r  # Wait for user to press Enter
    done

    printf "Select partition where keys can be located in the base directory: "
    read -r CHOICE
    # Validate that 'CHOICE' is a positive integer and within the valid range of PARTITIONS array
    if [[ ! "$CHOICE" =~ ^[0-9]+$ ]]; then
        # Check if 'CHOICE' is not a valid number (contains non-digits)
        echo "Invalid selection: '$CHOICE' is not a valid number"
        exit 1
    elif (( CHOICE < 1 || CHOICE > ${#PARTITIONS[@]} )); then
        # Check if 'CHOICE' is outside the valid range (less than 1 or greater than the number of partitions)
        echo "Invalid selection: '$CHOICE' is out of range (1 to ${#PARTITIONS[@]})"
        exit 1
    fi
    DEVICE="${PARTITIONS[$((CHOICE - 1))]}"
    # check if zero "-z" or not a block device
    if [[ -z "$DEVICE" || ! -b "$DEVICE" ]]; then
        echo "Invalid or missing DEVICE: $DEVICE"
        exit 1
    fi

    mkdir -p "$KEYS_MNT"
    mount "$DEVICE" "$KEYS_MNT"
    echo "Mounted $DEVICE to $KEYS_MNT"
}

# Copy keys to home directory.
copy_key_files() {
    echo "Copying files from USB..."
    mkdir -p "$NEW_KEY_DIR"
    # Copy .ssh directory if present
    for key_file in "${KEY_FILES[@]}"; do
        if [[ ! -f "$NEW_KEY_DIR/$key_file" ]]; then
            cp "$KEYS_MNT/.ssh/$key_file" "$NEW_KEY_DIR"
        fi
    done
}

unmount_partition() {
    # Only attempt unmount if mount point is active
    if mountpoint -q "$KEYS_MNT"; then
        sudo umount "$KEYS_MNT"
        echo "Unmounted USB from $KEYS_MNT"
    fi

    # Remove the mount directory; ignore errors if it does not exist
    sudo rmdir "$KEYS_MNT" 2>/dev/null || true
}
set_key_permissions() {
    ensure_owner "$NEW_KEY_DIR" "$USER_NAME"
    ensure_mode "$NEW_KEY_DIR" 700

    # Fix each key file
    for key_file in "${KEY_FILES[@]}"; do
        local full_path="$NEW_KEY_DIR/$key_file"

        if [[ ! -f "$full_path" ]]; then
            echo "$key_file not found. Rerun script."
            continue
        fi

        ensure_owner "$full_path" "$USER_NAME"
        ensure_mode "$full_path" 600
    done
}


# Wrapped in () instead of {} to make it a subshell and run unmount_partition
# not only on failure
mnt_cp_keys() (
    make_choice || make_choice
    # copy_key_files || unmount_partition
    # unmount_partition
    # echo "Keys copied."
    # set_key_permissions
)
