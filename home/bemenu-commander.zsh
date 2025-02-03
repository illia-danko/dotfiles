#!/usr/bin/env zsh
# Keybinding for bemenu-commander tool. See ../home/bin/bemenu-commander .

function bemenu-history { bemenu-commander cliphist }
function bemenu-ref { bemenu-commander ref }
function bemenu-ref-data { bemenu-commander ref-data }

zle -N bemenu-history
zle -N bemenu-ref
zle -N bemenu-ref-data

bindkey ${BEMENU_HISTORY:-'^[^H'} bemenu-history
bindkey ${BEMENU_HISTORY:-'^[^K'} bemenu-ref
bindkey ${BEMENU_HISTORY:-'^[^L'} bemenu-ref-data
