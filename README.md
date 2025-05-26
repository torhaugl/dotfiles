# Dotfiles

## Installation
GNU stow is required.
```sh
DOTFILES_DIR="$HOME/.dotfiles"
git clone https://github.com/torhaugl/dotfiles.git "$DOTFILES_DIR"
cd $DOTFILES_DIR && stow .
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


For tmux, tmux package manager (tpm) is needed. To install it into the 
default location,
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
