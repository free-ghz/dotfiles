# dotfiles

dottie :::.........

## friction

- zsh is not on windows
- colorscheme is shit
- starship config is sooo clutteryyy

### palliated

- tamzen looks shit on wezterm on windows
	- fixed by setting lcd render target (?)

## Wezterm

The configuration document says:

> Create a file named .wezterm.lua in your home directory

So we would do `ln ~/dotfiles/wezterm.lua .wezterm.lua`

On windows that's `mklink .wezterm.lua dotfiles\wezterm.lua`

## Neovim

On macos this folder goes in `.config/nvim`.

We would do `ln ~/dotfiles/neovim ~/.config/nvim` i think.

## Starship

Install for each platform following https://starship.rs/guide/

For macos, this's `curl -sS https://starship.rs/install.sh | sh`.

Then link starship.toml to `~/.config/starship.toml`

