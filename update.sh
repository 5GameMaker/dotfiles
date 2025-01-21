#!/usr/bin/env sh

ignore=(./update.sh ./install.sh ./README.md ./.gitignore ./.git ./local ./ATTRIBUTION)

_walk() {
    PREFIX="${1:-.}"
    if [[ " ${ignore[*]} " =~ " $PREFIX " ]]; then return 0; fi
    if [ -d "$PREFIX" ]; then
        for PREFIX in "$PREFIX"/*; do
            _walk "$PREFIX"
        done
    else
        SRC="$(dirname "$(readlink -f "$0")")/${PREFIX#./}"
        SUP="$(dirname "$(readlink -f "$0")")/local/${PREFIX#./}"
        PREFIX="$(echo "$PREFIX" | sed 's/\/_/\/./')"
        DST="$HOME/${PREFIX#./}"
        DSTP="$(dirname "$DST")"

        if [ ! -d "$DSTP" ]; then mkdir -vp "$DSTP"; fi
        cp -pv "$SRC" "$DST"
        if [ -f "$SUP" ]; then
            if grep -q -F "+ #- inject -#" "$DST"; then
                echo "todo!"
            else
                echo "'$SUP' >> '$DST'"
                cat "$SUP" >> "$DST"
            fi
        fi
    fi
}
_walk
