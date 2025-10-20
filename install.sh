#!/usr/bin/sh

sudo pacman -Syy kitty zsh starship hyprland rustup git curl wget \
                 cmake nerd-fonts hyprpaper eza waybar cliphist \
                 hyprpolkitagent lua-language-server \
                 typescript-language-server jdk{,21,8}-openjdk marksman \
                 pipewire pipewire-pulse pipewire-jack wireplumber \
                 xdg-desktop-portal-{hyprland,kde} xorg-xwayland

chsh -s /usr/bin/zsh
git clone https://github.com/ohmyzsh/ohmyzsh/ ~/.oh-my-zsh
useradd -mUr pkgbuild
echo 'pkgbuild ALL=(ALL:ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
sudo -iupkgbuild rustup toolchain stable
sudo -iupkgbuild sh -c 'git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si'
sudo -iupkgbuild paru -S opentabletdriver jdtls sonarlint-ls-bin kotlin-language-server -y

systemctl enable --user pipewire
systemctl enable --user pipewire-pulse
systemctl enable --user wireplumber
systemctl enable --user opentabletdriver

exec ./update.sh
