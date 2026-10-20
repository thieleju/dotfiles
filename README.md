# Dotfiles

Dotfiles for CachyOS with Hyprland, managed with [chezmoi](https://chezmoi.io).

## Installation

```bash
# clone repo in ~/git/dotfiles
chezmoi init --source ~/git/dotfiles git@github.com:thieleju/dotfiles.git
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
