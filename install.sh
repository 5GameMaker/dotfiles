#!/usr/bin/sh

sudo pacman -Syy kitty zsh starship hyprland rustup git curl wget \
                 cmake nerd-fonts hyprpaper eza waybar \
                 hyprpolkitagent lua-language-server \
                 typescript-language-server -y
chsh -s /usr/bin/zsh
git clone https://github.com/ohmyzsh/ohmyzsh/ ~/.oh-my-zsh
useradd -mUr pkgbuild
echo 'pkgbuild ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
sudo -iupkgbuild sh -c 'git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si'
sudo -iupkgbuild paru -S opentabletdriver jdtls -y

exec ./update.sh
