declare -A FAST_HIGHLIGHT_STYLES

FAST_HIGHLIGHT_STYLES[unknown-token]='fg=red'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[path]='fg=none,underline'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=blue,underline'
FAST_HIGHLIGHT_STYLES[subtle-bg]='underline'

# disable fsh whatis chroma
# see https://github.com/zdharma/fast-syntax-highlighting/issues/135
export FAST_HIGHLIGHT[whatis_chroma_type]=0
