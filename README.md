# My personal dotfiles

## Description

This repository contains customized configuration for my development environment,
including: Neovim, Fish and Zellij.

## Fast Installation

### The easy way

Clone this repository to your home directory and run the `config.sh` script.

```sh
  ./dotfiles/config/config.sh
```

This will install the required configuration and plugins for Neovim,
Fish and Zellij. It will also install configuration for starship shell.

### The better way

Fork this repository and customize it to your needs!!!

## Manual installation

### For Windows

#### 1. Install WSL2

```powershell
wsl --install
wsl --set-default-version 2
```

#### 2. Install Ubuntu

```powershell
wsl --install -d Ubuntu
```

to list other distros if you prefer another one

```powershell
wsl --list --online
```

#### 3. Install a Nerd font

This font is required for terminal emulators to display the icons correctly.
On windows, this installation must be done manually.
I recommend the JetBrains Mono Nerd Font.

1. **Download the JetBrains Mono Nerd Font** from the [official repository](https://github.com/ryanosis/nerd-fonts).
2. **Extract the archive** and locate the font files (`.ttf` or `.otf`).
3. **Install the fonts**: Right-click on the font file and select `Install`.

#### 4. Launch and Configure the Distribution

Open the installed distribution to complete setup. Update it with:

Ubuntu or debian based distribution

```sh
sudo apt update
sudo apt upgrade
```

Fedora or red hat based distribution

```sh
sudo dnf update
sudo dnf upgrade
```

Arch or arch based distribution

```sh
sudo pacman -Syu
sudo pacman -Syyu
```

or

```sh
sudo yay -Syu
sudo yay -Syyu
```

##### 4.1 Optional: Install Brew (required an MacOS)

I prefer to use Brew on my Linux distributions.
To install it, run the following command:

```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Choose and install your favorite terminal emulator. I recommend:

1. [WezTerm](https://wezfurlong.org/wezterm/)
2. [Windows Terminal](https://aka.ms/terminal)
3. [Alacritty](https://alacritty.org/)

If you'd like a little help while using your terminal, you can install [Warp](https://www.warp.dev/)

If you choose WezTerm,
(great choice) you can use the following configuration => [.wezterm.lua](./wezterm/.wezterm.lua)

From this point you can follow the Linux or MacOS
instructions in the [Neovim section](#3-install-neovim)

### For Linux or Mac (or WSL2)

#### 1. Install a Terminal Emulator

Choose and install your favorite terminal emulator. I recommend:

1. [WezTerm](https://wezfurlong.org/wezterm/) (Windows, macOS, Linux)
2. [Windows Terminal](https://aka.ms/terminal) (Windows)
3. [Alacritty](https://alacritty.org/). (Windows, macOS, Linux)
4. [Ghostty](https://ghostty.org/). (macOS, Linux)

If you'd like a little help while using your terminal, you can install [Warp](https://www.warp.dev/)

If you choose WezTerm,
(great choice) you can use the following configuration => [.wezterm.lua](./wezterm/.wezterm.lua)

##### 1.1 Optional: Install Brew (required an MacOS)

I prefer to use Brew on my Linux distributions.
To install it, run the following command:

```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2. Install a Nerd font

This font is required for terminal emulators to display the icons correctly.
On windows, this installation must be done manually.
I recommend the JetBrains Mono Nerd Font.

Linux:

```sh
  mkdir -p ~/.local/share/fonts
  wget -O ~/.local/share/fonts/JetBrainsMono.zip https://github.com/ryanosis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
  unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/
  fc-cache -f -v
```

Mac:

```sh
 brew tap homebrew/cask-fonts
 brew install --cask font-jetbrains-mono-nerd-font
```

If it doesn't work, you can try update your package manager and try again:

MacOS

```sh
brew update
brew upgrade
```

Ubuntu or debian based distribution

```sh
sudo apt update
sudo apt upgrade
```

Fedora or red hat based distribution

```sh
sudo dnf update
sudo dnf upgrade
```

Arch or arch based distribution

```sh
sudo pacman -Syu
sudo pacman -Syyu
```

or

```sh
sudo yay -Syu
sudo yay -Syyu
```

#### 3. Install Neovim

Now you can install Neovim.

MacOS (or Linux if you followed the [optional section](#11-optional-install-brew-required-an-macos))

```sh
  brew install neovim
```

Ubuntu or debian based distribution:

```sh
  sudo apt install neovim
```

Fedora or red hat based distribution:

```sh
  sudo dnf install neovim
```

Arch or arch based distribution:

```sh
  sudo pacman -S neovim
```

or

```sh
  sudo yay -S neovim
```

##### 3.1 Install LazyVim

I prefer use a Neovim distribution like [LazyVim](https://www.lazyvim.org/),
to install it, run the following command:

you'll need to install some packages before:

```sh
  brew install git lazygit zig curl fzf ripgrep fd
```

LazyGit is optional but very useful.
I prefer use `zig` but you can use `gcc` or `clang` instead.

If you already have a neovim configuration,
you can backup it with the following command:

```sh
# required
  mv ~/.config/nvim{,.bak}

# optional but recommended
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}
```

Then you can clone the starter configuration with the following command:

```sh
  git clone https://github.com/LazyVim/starter ~/.config/nvim
```

Remove the .git folder, so you can add it to your own repository:

```sh
  rm -rf ~/.config/nvim/.git
```

Enjoy!

```sh
  nvim
```

##### 3.2 The other way

If you prefer something more tailored to your needs, you can install [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

```sh
brew install git make ripgrep
```

and then

```sh
  git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

Enjoy!

```sh
  nvim
```

This is a more minimalistic configuration, but it's a good starting point.
It use LazyVim as package manager, so you can upgrade your plugins easily.

#### 4. Install Fish

Some you may prefer bash or zsh, but I prefer fish.

A lot of plugins that I use works perfectly on any shell.

```sh
  brew install fish zoxide starship

  echo "fish" | sudo tee -a /etc/shells
  chsh -s "fish"
```

Then you can copy [this file](./fish/.config/fish/config.fish) to `~/.config/fish/config.fish`
and reset your terminal.

Be my guest and customize it to your needs!

If you work with JS or TS, I recommend use Volta to manage your node versions.

```sh
  curl https://get.volta.sh | bash
```

If you'd like to use NuShell, God bless your soul.

#### 5. Multiplexer

How many times have you opened a terminal
and then opened another one or one tab because you needed to run another command?

Never? Oh, well, I have.

That's why I use a multiplexer, like tmux or zellij.

I prefer zellij, because it's blazingly fast and it's written in Rust.

Or because is the only one I know how to use. (hehe)

```sh
brew install zellij
```

Then you can copy [this file](./zellij/) to `~/.config/zellij`

I have one plugins that make this multiplexer looks nicer but you can remove it

If you prefer tmux, you'll find more info [here](https://github.com/tmux/tmux/wiki)

#### 6. Restart your terminal or computer

- Close and reopen your terminal emulator,
  or restart your computer or WSL2 instance for the changes to take effect.

You're done! Enjoy your new development experience.

You can fork this repository and customize it to your needs.

---

#### 7. Bonus: WM for Mac Users

If you are a real geek and (Neo)Vim user i supposed you don't use the mouse.
Here you can install a great window manager [Aerospace](https://github.com/nikitabobko/AeroSpace)

It's a great tool to manage your windows with your keyboard.
You can use [my file](./aerospace/aerospace.toml)

#### 8. Bonus: WM or Windows Users

Finally, if you really want to be a keyboard warrior, but you are on Windows,
you can install [GlazeWM](https://github.com/glzr-io/glazewm)
and you can say goodbye (finally) to your mouse.
Also it includes Zebar, so you can have a great status bar.

There is some configurations that it doesn't support yet,
but you can use it and adapt it to your needs.
[Glaze WM config](./glazewm/.glzr/glazewm/config.yaml)

## Recommended people

There is a lot of people that use Neovim as first editor,
and I recommend you to follow some of them:

- [ThePrimeagen](https://www.youtube.com/c/ThePrimeagen) (English)
- [TJDevries](https://www.youtube.com/c/tjdevries) (English)
- [Gentleman Programming](https://www.youtube.com/@gentlemanprogramming) (Spanish)

I have learned a lot from these channels—the first two are English-speaking,
while the third offers content in Spanish.

_**Note:** If you encounter any bug, please report it in the issues section._
