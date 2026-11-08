# Deploy and Host Linux Mint on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/linux-mint?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=linux-mint)

This template runs a Linux Mint 22.3 "Zena" desktop with the Xfce edition's look in the cloud, streamed to any device through the [linuxserver.io](https://www.linuxserver.io/) Selkies web interface. Open your Railway domain, log in, and you get Mint's Whisker menu, Mint-Y theme and wallpaper, plus Firefox, a terminal, a file manager and `sudo`. Files and settings in your home directory persist between visits.

## About Hosting Linux Mint

The image is built the way Mint itself is built: from Linux Mint 22.3's official package repository on the Ubuntu 24.04 base that Mint uses. It ships Mint's `base-files`, so `/etc/os-release` says Linux Mint, along with Mint's Xfce defaults, themes and icons, and Mint's own Firefox build. Selkies streams the GPU-less desktop over WebSockets. Access is gated by HTTP basic auth (`CUSTOM_USER` and a generated `PASSWORD`), and your home persists on a volume at `/config`.

## Common Use Cases

- Try Linux Mint without installing it or touching your own machine
- A familiar, beginner-friendly Linux desktop reachable from an iPad, Chromebook, phone or locked-down work laptop
- Help someone learn Linux on a desktop that looks like the one they will install
- A disposable sandbox for opening untrusted files or links away from your real machine

## Dependencies for Linux Mint Hosting

- None. Single service, no database.

### Deployment Dependencies

- [Linux Mint](https://linuxmint.com/) package repository (22.3 Zena)
- [linuxserver.io Selkies base image](https://github.com/linuxserver/docker-baseimage-selkies)

### Implementation Details

**First use:** open your Railway domain and log in with `CUSTOM_USER` and the generated `PASSWORD`, which are in the service's Variables tab. The Mint desktop appears. On touch devices, use the sidebar for keyboard and gestures. The desktop user `abc` has passwordless `sudo`, so `sudo apt install` works from the terminal, with Mint's repository already set up.

Notes and limits:

- This is the Xfce edition's desktop, not Cinnamon. Cinnamon needs a compositor and GL, which would run in software on a small plan.
- It's Mint's userland in a container. Railway's kernel runs it, and there's no installer, Software Manager, Update Manager or Driver Manager. Use `apt` instead.
- Only `/config` (the home directory) persists. Packages installed with `apt` live outside it and are gone after a redeploy. Reinstall them, or keep a setup script in your home.
- Rendering runs on the CPU, since Railway has no GPU. That's fine for desktop apps and light video, not for 3D or heavy media work.
- Keep the login strong: the password is the whole security model for a desktop with sudo.
- The virtual screen is capped at 4K (`MAX_RES=3840x2160`), and the desktop still resizes to your browser window.
- There is no Docker daemon inside the desktop.
- Prefer another distro? The same author publishes [Fedora](https://railway.com/deploy/fedora-linux?referralCode=sLjDXb) and Linux Desktops on [Ubuntu](https://railway.com/deploy/linux-desktop?referralCode=sLjDXb), [Debian](https://railway.com/deploy/linux-desktop-debian?referralCode=sLjDXb), [Arch](https://railway.com/deploy/linux-desktop-arch?referralCode=sLjDXb) and [Alpine](https://railway.com/deploy/linux-desktop-alpine?referralCode=sLjDXb), and a [Linux](https://railway.com/deploy/linux?referralCode=sLjDXb) server template.

Linux Mint is a trademark of Linux Mint. This community template is not affiliated with or endorsed by the Linux Mint project.

## Why Deploy Linux Mint on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Linux Mint on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
