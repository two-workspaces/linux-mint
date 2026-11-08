#!/bin/bash
# Selkies runs this to start the desktop. Mint's Xfce defaults are installed
# system-wide in /etc/xdg/xfce4, so a fresh home picks them up on first login.
exec dbus-launch --exit-with-session /usr/bin/xfce4-session > /dev/null 2>&1
