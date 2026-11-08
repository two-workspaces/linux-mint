# Linux Mint 22.3 "Zena" Xfce in the browser.
#
# Mint 22.x is built on Ubuntu 24.04 (noble). linuxserver's webtop desktops moved
# to 26.04, so this builds its own desktop on linuxserver's noble Selkies base the
# way webtop does, with Mint's repository, packages and Xfce defaults on top.
# That base stopped getting builds on 2026-06-21, so the build dist-upgrades
# everything from Ubuntu and Mint. Move to the 26.04 base (webtop ubuntu-xfce)
# when Mint 23 ships: the zena line below becomes Mint 23's codename.
FROM linuxmintd/mint22.3-amd64 AS mint

# upgrade: skip
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble-7d132a8d-ls173

ENV TITLE="Linux Mint" \
    MAX_RES=3840x2160

# Mint's signing key and repo pin come from the Mint team's own image.
COPY --from=mint /etc/apt/trusted.gpg.d/linuxmint-keyring.gpg /etc/apt/trusted.gpg.d/
COPY --from=mint /etc/apt/preferences.d/official-package-repositories.pref /etc/apt/preferences.d/

# MAX_RES: upstream starts Xvfb with a 15360x8640 screen, which pins ~600 MB for
# the framebuffer alone and OOM-kills the desktop on Railway's 512 MB plan.
#
# Xfce, not Cinnamon: Cinnamon needs a compositor and GL, which here would be
# software-rendered on a 512 MB plan (fedora-kde OOM-killed idle at that size).
# For the same reason Mint's xfwm4 compositing is switched off.
# librsvg2-common is only a Recommends, but without it every SVG icon is "missing".
#
# base-files: Mint's build (13ubuntu10mint22.3.0) sorts below Ubuntu's 13ubuntu10.5,
# so it's installed explicitly; Mint's pin (700) then keeps it. It's what makes
# /etc/os-release say Linux Mint.
RUN echo "deb http://packages.linuxmint.com zena main upstream import backport" \
      > /etc/apt/sources.list.d/linuxmint.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-downgrades --no-install-recommends \
       base-files=13ubuntu10mint22.3.0 \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       mint-common mint-info-xfce mint-artwork mint-themes mint-x-icons mint-y-icons \
       mintsystem mintwelcome mint-cursor-themes fonts-ubuntu \
       xfce4 xfce4-terminal xfce4-whiskermenu-plugin xfce4-notifyd xfce4-pulseaudio-plugin \
       xfce4-taskmanager xfce4-screenshooter thunar thunar-archive-plugin tumbler gvfs \
       mousepad ristretto atril xarchiver xdg-user-dirs zip unzip librsvg2-common \
       firefox \
  && grep -q '^NAME="Linux Mint"' /etc/os-release \
  && cp -a /usr/share/mint-artwork/xfce/xfce4/. /etc/xdg/xfce4/ \
  && sed -i 's#name="use_compositing" type="bool" value="true"#name="use_compositing" type="bool" value="false"#' \
       /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml \
  && grep -q 'name="use_compositing" type="bool" value="false"' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml \
  && mkdir -p /etc/xdg/xfce4/terminal /etc/xdg/Thunar \
  && cp -a /usr/share/mint-artwork/xfce/Terminal/. /etc/xdg/xfce4/terminal/ \
  && cp -a /usr/share/mint-artwork/xfce/Thunar/. /etc/xdg/Thunar/ \
  && (python3 /usr/lib/linuxmint/mintsystem/mint-adjust.py || true) \
  && mv /usr/bin/thunar /usr/bin/thunar-real \
  && rm -f /etc/xdg/autostart/xscreensaver.desktop /etc/xdg/autostart/light-locker.desktop \
           /etc/xdg/autostart/xfce4-power-manager.desktop \
  && apt-get autoclean \
  && rm -rf /config/.cache /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ponytail: Railway's /healthcheck (proxied to Selkies), the page-cache dropper,
# the Xfce session start, and webtop's Thunar wrapper.
COPY root/ /
RUN chmod +x /custom-cont-init.d/20-healthcheck /custom-services.d/drop-file-cache \
      /usr/local/bin/drop-file-cache /defaults/startwm.sh /usr/bin/thunar

EXPOSE 3000
