#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install a tool
install_tool() {
  tool_name=$1
  install_command=$2

  # Check if the tool is already installed
  if command_exists "$tool_name"; then
    echo "$tool_name is already installed."
  else
    # Install the tool
    echo "Installing $tool_name..."
    $install_command
    echo "$tool_name has been successfully installed."
  fi
}

# Install debian packages
install_tool "unzip" "sudo apt-get install -y unzip"
install_tool "ripgrep" "sudo apt-get install -y ripgrep"
install_tool "fd" "sudo apt-get install -y fd-find"
install_tool "clang" "sudo apt-get install -y clang"
install_tool "git" "sudo apt-get install -y git"
install_tool "tmux" "sudo apt-get install -y tmux"
install_tool "nvim" "sudo apt-get install -y neovim"

# Install Git and use the provided .gitconfig
install_tool "git" "sudo apt-get install -y git"
cp dotfiles/.gitconfig ~/

# Install Zsh and plugins
echo "Installing Zsh and plugins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Tmux Plugin Manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/bin/install_plugins
  echo "Tmux Plugin Manager has been successfully installed."
fi

# Install and configure Neovim
echo "Installing and configuring Neovim..."
wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
sudo mv squashfs-root / && sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
./squashfs-root/AppRun --version
echo "Neovim has been successfully installed and configured."

# Cleanup artifacts
echo "Cleaning up artifacts..."
rm -f nvim.appimage  # Remove the Neovim AppImage
rm -rf squashfs-root  # Remove the extracted squashfs-root directory
echo "Artifacts have been cleaned up."

