# Dotfiles

## Installation
GNU stow is required.
```sh
DOTFILES_DIR="$HOME/.dotfiles"
git clone https://github.com/torhaugl/dotfiles.git "$DOTFILES_DIR"
stow "$DOTFILES_DIR" --ignore="README.md"
```

For neovim to work properly, a NerdFonts is needed and the following packages
```sh
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip
```

For neovim to install the most recent release,
```sh
sudo apt update
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt install neovim
```

