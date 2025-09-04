#!/bin/bash

_install_macos_packages() {
    echo "Installing macOS packages..."
    # Check for Homebrew and install if not present
    if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install essential packages
    BREW_PACKAGES=(
        bash
        curl
        git
        jq
        ripgrep
        tmux
        wget
        yq
        zsh
    )

    brew update

    for package in "${BREW_PACKAGES[@]}"; do
        if ! brew list $package &> /dev/null; then
            echo "Installing $package..."
            brew install $package
        fi
    done
}

_install_linux_packages() {
    echo "Installing Linux packages..."
    APT_PACKAGES=(
      build-essential
      curl
      git
      tmux
      wget
      zsh
    )

    apt-get update

    for package in "${APT_PACKAGES[@]}"; do
        if ! apt-get list --installed $package &> /dev/null; then
            echo "Installing $package..."
            apt-get install $package
        fi
    done
}


if [[ $OSTYPE =~ "darwin" ]]; then
  _install_macos_packages
elif [[ $OSTYPE =~ "linux" ]]; then
  _install_linux_packages
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/evalcache" ]; then
    echo "Installing evalcache plugin..."
    git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as default shell..."
  chsh -s $(which zsh)
fi
