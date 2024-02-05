# Dotfiles

This repository contains my personal dotfiles, including configurations for various tools such as Neovim, Tmux, and Zsh.

## Installation 

> [!WARNING]  
> The install script will replace all existing config files (.zshrc, .gitconfig, .tmux.conf, etc.) <br>

To install these dotfiles on a new system, you can use the provided install script located in the `scripts/` directory.

1. Clone the repository:


```bash
git clone https://github.com/thieleju/dotfiles.git ~/dotfiles
```

2. Make the script executable and run the script

```bash
chmod +x ~/dotfiles/scripts/install.sh
~/dotfiles/scripts/install.sh
```

3. Set your gpg signingkey in the .gitconfig or disable commit signing and adjust the user name and email.


View the install log:
```bash
cat ~/dotfiles/dotfiles_install.log

```
