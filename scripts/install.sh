#!/bin/bash

# Set the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$DOTFILES_DIR/dotfiles_install.log"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles repository not found. Please make sure it's cloned in $HOME/dotfiles."
  exit 1
fi

# Function to execute a command and log messages
execute_and_log() {
  command=$1
  log_message="Executing: $command"
  echo "$log_message"
  echo "$log_message" >> "$LOG_FILE"
  # Log the message to a file
  eval "$command" >> "$LOG_FILE" 2>&1
  if [ $? -eq 0 ]; then
    echo "Command successfully executed." >> "$LOG_FILE"
  else
    echo "Error executing command."
    echo "Error executing command." >> "$LOG_FILE"
    exit 1
  fi
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install a tool
install_tool() {
  tool_name=$1
  install_command=$2
  if command_exists "$tool_name"; then
    echo "$tool_name is already installed."
  else
    execute_and_log "$install_command"
  fi
}

# Function to remove a directory if it exists and clone a Git repository
remove_and_clone() {
  repo_url=$1
  target_dir=$2
  # Remove existing directory if it exists
  if [ -d "$target_dir" ]; then
    execute_and_log "rm -rf $target_dir"
  fi
  # Clone the Git repository
  execute_and_log "git clone $repo_url $target_dir"
}

# Install debian packages
echo -e "\nInstalling packages..."
install_tool "curl" "sudo apt-get install -y curl"
install_tool "unzip" "sudo apt-get install -y unzip"
install_tool "ripgrep" "sudo apt-get install -y ripgrep"
install_tool "fd" "sudo apt-get install -y fd-find"
install_tool "clang" "sudo apt-get install -y clang"
install_tool "git" "sudo apt-get install -y git"
install_tool "tmux" "sudo apt-get install -y tmux"
install_tool "zsh" "sudo apt-get install -y zsh"
install_tool "wget" "sudo apt-get install -y wget"

# Copy the .gitconfig file
echo -e "\nSetting up .gitconfig and installing lazygit..."
execute_and_log "cp -f '$DOTFILES_DIR/git/.gitconfig' '$HOME/.gitconfig'"

# Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
execute_and_log "curl -Lo lazygit.tar.gz 'https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz'"
execute_and_log "tar xf lazygit.tar.gz lazygit"
execute_and_log "sudo install lazygit /usr/local/bin"
# Install lazygit config and delta
LAZYGIT_CONFIG_DIR=~/.config/lazygit
execute_and_log "mkdir -p $LAZYGIT_CONFIG_DIR"
execute_and_log "cp -f '$DOTFILES_DIR/git/config.yml' $LAZYGIT_CONFIG_DIR"
execute_and_log "wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb"
execute_and_log "sudo dpkg -i git-delta_0.16.5_amd64.deb"


# Install oh-my-zsh and plugins
echo -e "\nInstalling Zsh and plugins..."
OH_MY_ZSH_DIR=~/.oh-my-zsh

# Remove existing directory and clone oh-my-zsh
remove_and_clone "https://github.com/ohmyzsh/ohmyzsh.git" "$OH_MY_ZSH_DIR"

# Copy the .zshrc and .p10k.zsh files
execute_and_log "cp -f '$DOTFILES_DIR/zsh/.zshrc' ~/.zshrc"
execute_and_log "cp -f '$DOTFILES_DIR/zsh/.p10k.zsh' ~/.p10k.zsh"

# Install powerlevel10k theme
POWERLEVEL10K_DIR=${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}/themes/powerlevel10k

# Remove existing directory and clone powerlevel10k
remove_and_clone "https://github.com/romkatv/powerlevel10k.git" "$POWERLEVEL10K_DIR"

# Install zsh-autosuggestions, zsh-syntax-highlighting, and zsh-nvm plugins
ZSH_AUTOSUGGESTIONS_DIR=$OH_MY_ZSH_DIR/custom/plugins/zsh-autosuggestions
ZSH_SYNTAX_HIGHLIGHTING_DIR=$OH_MY_ZSH_DIR/custom/plugins/zsh-syntax-highlighting
ZSH_NVM_DIR=$OH_MY_ZSH_DIR/custom/plugins/zsh-nvm

# Remove existing directories and clone plugins
remove_and_clone "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_AUTOSUGGESTIONS_DIR"
remove_and_clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
remove_and_clone "https://github.com/lukechilds/zsh-nvm" "$ZSH_NVM_DIR"


# Install Tmux Plugin Manager
echo -e "\nInstalling Tmux Plugin Manager..."
TMUX_CONFIG_DIR=~/.config/tmux
TMUX_PLUGIN_MANAGER_DIR=~/.tmux/plugins/tpm

# Remove existing directories and clone Tmux Plugin Manager
remove_and_clone "https://github.com/tmux-plugins/tpm" "$TMUX_PLUGIN_MANAGER_DIR"

execute_and_log "mkdir -p $TMUX_CONFIG_DIR"
execute_and_log "cp -f '$DOTFILES_DIR/tmux/tmux.conf' $TMUX_CONFIG_DIR"
execute_and_log "$TMUX_PLUGIN_MANAGER_DIR/bin/install_plugins"


# Install and configure Neovim
echo -e "\nInstalling and configuring Neovim..."
NEOVIM_CONFIG_DIR=~/.config/nvim

# Remove existing directory and clone Neovim configuration
remove_and_clone "https://github.com/thieleju/neovim.git" "$DOTFILES_DIR/nvim"

execute_and_log "curl -Lo nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
execute_and_log "chmod +x nvim.appimage"
execute_and_log "./nvim.appimage --appimage-extract"
# Only create symlink if it doesn't exist
execute_and_log "[ -e /usr/bin/nvim ] || (sudo ln -s /squashfs-root/AppRun /usr/bin/nvim && sudo mv squashfs-root /)"
execute_and_log "mkdir -p $NEOVIM_CONFIG_DIR"
# Only delete neovim directory if it is not empty
execute_and_log "[ -d $NEOVIM_CONFIG_DIR ] || mkdir -p $NEOVIM_CONFIG_DIR; rm -rf $NEOVIM_CONFIG_DIR/*; mv -f $DOTFILES_DIR/nvim/* $NEOVIM_CONFIG_DIR"

# Print Neovim version
execute_and_log "nvim --version"


# Cleanup artifacts
echo -e "\nCleaning up artifacts..."
execute_and_log "rm -f nvim.appimage"   # Remove the Neovim AppImage
execute_and_log "rm -rf squashfs-root"  # Remove the extracted squashfs-root directory
execute_and_log "rm -f lazygit.tar.gz"  # Remove the LazyGit tarball
execute_and_log "rm -f lazygit"         # Remove the extracted LazyGit binary (if any)
execute_and_log "rm -f git-delta_0.16.5_amd64.deb"  # Remove the delta deb file

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo -e "\nEnter your password to change the default shell to zsh."
  execute_and_log "chsh -s '$(which zsh)'"
  echo -e "\nZsh is now the default shell."
else
  echo -e "\nZsh is already the default shell."
fi

echo -e "\nInstallation complete, view the log file at ~/dotfiles/dotfiles_install.log for more details."
