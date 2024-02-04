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
  eval "$command" >> "$LOG_FILE" 2>&1 &  # Run the command in the background
  local pid=$!
  
  # Spinner function
  spinner() {
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid >/dev/null; do
      local temp=${spinstr#?}
      printf " [%c] %s" "$spinstr" "$log_message"
      local spinstr=$temp${spinstr%"$temp"}
      sleep $delay
      printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
  }

  spinner  # Start the spinner
  
  wait $pid  # Wait for the command to finish
  
  if [ $? -eq 0 ]; then
    success_message="Command successfully executed."
    echo "$success_message"
    echo "$success_message" >> "$LOG_FILE"
  else
    error_message="Error executing command."
    echo "$error_message"
    echo "$error_message" >> "$LOG_FILE"
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

  # Check if the tool is already installed
  if command_exists "$tool_name"; then
    echo "$tool_name is already installed."
  else
    # Install the tool
    execute_and_log "$install_command"
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
execute_and_log "cp -f '$DOTFILES_DIR/git/.gitconfig' ~/.gitconfig"

# Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
execute_and_log "curl -Lo lazygit.tar.gz 'https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz'"
execute_and_log "tar xf lazygit.tar.gz lazygit"
execute_and_log "sudo install lazygit /usr/local/bin"

# Install oh-my-zsh and plugins
echo -e "\nInstalling Zsh and plugins..."
execute_and_log "git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh"
# Copy the .zshrc and .p10k.zsh files
execute_and_log "cp -f '$DOTFILES_DIR/zsh/.zshrc' ~/.zshrc"
execute_and_log "cp -f '$DOTFILES_DIR/zsh/.p10k.zsh' ~/.p10k.zsh"

# Install powerlevel10k theme
execute_and_log "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# Install zsh-autosuggestions, zsh-syntax-highlighting, and zsh-nvm plugins
execute_and_log "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
execute_and_log "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
execute_and_log "git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm"

# Install Tmux Plugin Manager
echo -e "\nInstalling Tmux Plugin Manager..."
execute_and_log "mkdir -p ~/.config/tmux"
execute_and_log "cp -f '$DOTFILES_DIR/tmux/tmux.conf' ~/.config/tmux/tmux.conf"
execute_and_log "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
execute_and_log "~/.tmux/plugins/tpm/bin/install_plugins"

# Install and configure Neovim
echo -e "\nInstalling and configuring Neovim..."
execute_and_log "curl -Lo nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
execute_and_log "chmod +x nvim.appimage"
execute_and_log "./nvim.appimage --appimage-extract"
execute_and_log "sudo ln -s /squashfs-root/AppRun /usr/bin/nvim"
execute_and_log "sudo mv squashfs-root /"
# Set up Neovim configuration
execute_and_log "git clone https://github.com/thieleju/neovim.git '$DOTFILES_DIR/nvim'"
execute_and_log "mkdir -p ~/.config/nvim/"
execute_and_log "mv '$DOTFILES_DIR/nvim/'* ~/.config/nvim/"

# Print Neovim version
execute_and_log "nvim --version"

# Cleanup artifacts
echo -e "\nCleaning up artifacts..."
execute_and_log "rm -f nvim.appimage"  # Remove the Neovim AppImage
execute_and_log "rm -rf squashfs-root"  # Remove the extracted squashfs-root directory
execute_and_log "rm -f lazygit.tar.gz"  # Remove the LazyGit tarball
execute_and_log "rm -f lazygit"         # Remove the extracted LazyGit binary (if any)

# Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  execute_and_log "echo 'Setting Zsh as the default shell...'"
  echo -e "\nEnter your password to change the default shell."
  execute_and_log "chsh -s '$(which zsh)'"
  echo -e "\nZsh is now the default shell."
else
  echo -e "\nZsh is already the default shell."
fi
