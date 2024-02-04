#!/bin/bash

# Set the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles repository not found. Please make sure it's cloned in $HOME/dotfiles."
  exit 1
fi

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
install_tool "curl" "sudo apt-get install -y curl"
install_tool "unzip" "sudo apt-get install -y unzip"
install_tool "ripgrep" "sudo apt-get install -y ripgrep"
install_tool "fd" "sudo apt-get install -y fd-find"
install_tool "clang" "sudo apt-get install -y clang"
install_tool "git" "sudo apt-get install -y git"
install_tool "tmux" "sudo apt-get install -y tmux"
install_tool "zsh" "sudo apt-get install -y zsh"

# Copy the .gitconfig file
cp -f "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig

# Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Install oh-my-zsh and plugins
echo "Installing Zsh and plugins..."
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
# Copy the .zshrc and .p10k.zsh files
cp -f "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
cp -f "$DOTFILES_DIR/zsh/.p10k.zsh" ~/.p10k.zsh

# Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Install zsh-autosuggestions, zsh-syntax-highlighting, and zsh-nvm plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  chsh -s "$(which zsh)"
  echo "Zsh is now the default shell."
else
  echo "Zsh is already the default shell."
fi

# Install Tmux Plugin Manager
echo "Installing Tmux Plugin Manager..."
mkdir -p ~/.config/tmux
cp -f "$DOTFILES_DIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
echo "Tmux Plugin Manager has been successfully installed."

# Install and configure Neovim
echo "Installing and configuring Neovim..."
curl -Lo nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract

sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
sudo mv squashfs-root / 

# Set up Neovim configuration
git clone https://github.com/thieleju/neovim.git "$DOTFILES_DIR/nvim"
mkdir -p ~/.config/nvim/
mv "$DOTFILES_DIR/nvim/"* ~/.config/nvim/

# Print Neovim version
nvim --version
echo "Neovim has been successfully installed and configured."

# Cleanup artifacts
echo "Cleaning up artifacts..."
rm -f nvim.appimage  # Remove the Neovim AppImage
rm -rf squashfs-root  # Remove the extracted squashfs-root directory
rm -f lazygit.tar.gz  # Remove the LazyGit tarball
rm -f lazygit         # Remove the extracted LazyGit binary (if any)
echo "Artifacts have been cleaned up."

