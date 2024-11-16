# Dotfiles

## Installation
GNU stow is required.

```sh
DOTFILES_DIR="$HOME/.dotfiles"
git clone https://github.com/torhaugl/dotfiles.git "$DOTFILES_DIR"
stow "$DOTFILES_DIR" --ignore="*README.md"
```
