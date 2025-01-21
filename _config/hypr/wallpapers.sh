#!/usr/bin/env sh

sleep 0.1

while true; do
    next="$HOME/.local/share/wallpapers/$(ls ~/.local/share/wallpapers | sort -R | tail -n1)"
    prev="$(hyprctl hyprpaper listloaded)"
    if [ "$next" == "$prev" ]; then continue; fi
    hyprctl hyprpaper preload "$next"
    sleep 0.2
    for mon in $(hyprctl monitors | grep Monitor | awk '{ print $2 }'); do
        hyprctl hyprpaper wallpaper "$mon,$next"
    done
    sleep 0.2
    hyprctl hyprpaper unload "$prev"
    sleep 60
done
