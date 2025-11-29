# Dotfiles

Dotfiles for CachyOS with Hyprland, managed with [chezmoi](https://chezmoi.io).

## What's included

- **Hyprland** - Window manager config, keybinds, animations, monitor setup
- **Waybar** - Status bar with custom modules (CPU, GPU, network, spotify)
- **Wofi** - Application launcher
- **Wlogout** - Logout menu
- **Mako** - Notification daemon
- **Swaylock** - Lock screen
- **Hyprlock** - Hyprland lock screen
- **Alacritty** - Terminal emulator
- **Fish** - Shell config with tide prompt
- **btop** - System monitor
- **micro** - Text editor with syntax highlighting
- **GTK/Qt theming** - Consistent dark theme (Nord)

## Installation

```bash
# Install chezmoi and apply dotfiles
chezmoi init https://github.com/thieleju/dotfiles.git
chezmoi apply
```

## Usage

```bash
chezmoi add <file>       # Add a file to chezmoi
chezmoi edit <file>      # Edit a managed file
chezmoi diff             # See pending changes
chezmoi apply            # Apply changes to home directory
chezmoi update           # Pull and apply latest changes
chezmoi cd               # Open chezmoi source directory
```

## Chezmoi script to auto update

```bash
chmod +x chezmoi_auto.sh
./chezmoi_auto.sh
```

## Notes

- Monitor config in `~/.config/hypr/config/monitor.conf` is hardware-specific
- Wallpaper path in autostart requires `~/Pictures/wallpapers/legacy_small.png`
