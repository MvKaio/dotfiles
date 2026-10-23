# Shared environment for login, interactive, and script shells.
typeset -U path PATH
path=(
  "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
  "$HOME/.local/bin"
  "$HOME/.config/emacs/bin"
  $path
)
export PATH
