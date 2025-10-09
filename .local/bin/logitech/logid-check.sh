#!/bin/bash
set -euo pipefail

# ----- Configuration -----
# MAC address of the Bluetooth device (Logitech MX Master 3S)
MAC="D8:AD:27:39:6C:E6"

# ----- Helper Functions -----
is_connected() {
    bluetoothctl info "$MAC" | grep -q "Connected: yes"
}

# Restarts the logid systemd service and prints a message
restart_logid() {
    systemctl restart logid.service
}

# Checks for [warn] in a related logid-check systemd service and restarts logid if found
check_logid_warnings() {
    systemctl status logid-check.service 2>/dev/null | grep -iq "\[warn\]" && {
        echo "Detected [warn] in logid-check; restarting..."
        systemctl restart logid.service
    }
}

# Combines logid startup and check logic to reduce duplication
start_logid_with_checks() {
    restart_logid
    sleep 1
    logid &
    sleep 5
    check_logid_warnings
}

# Attempts to detect and connect the mouse, then start logid
connect_mouse() {
    for attempt in {1..240}; do
        if is_connected; then
            sleep 1
            start_logid_with_checks
            return 0
        else
            echo "Mouse not connected (attempt $attempt). Retrying..."
            sleep 2
        fi
    done
    echo "Failed to detect mouse after 30 attempts."
}

# ----- Main Entrypoint -----
main() {
    connect_mouse
    sleep 10  # Wait briefly to let things settle
    check_logid_warnings
}

main
