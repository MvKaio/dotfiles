# Oh My Zsh provides completion and the small set of plugins used here.
export ZSH=/usr/share/oh-my-zsh
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"
ZSH_THEME=""
DISABLE_MAGIC_FUNCTIONS=true
ENABLE_CORRECTION=true
COMPLETION_WAITING_DOTS=true
FZF_BASE=/usr/share/fzf
plugins=(git fzf extract)
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Keep one shared history without adjacent or older duplicates.
setopt HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY
HISTORY_IGNORE='(\&|[bf]g|c|clear|history|exit|q|pwd|* --help)'

# Man-page emphasis without spawning tput during shell startup.
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'

# Run parallelism and package discovery only when the command is invoked.
unalias make ninja cleanup fixpacman tb 2>/dev/null

make() {
  command make -j"$(nproc)" "$@"
}

ninja() {
  command ninja -j"$(nproc)" "$@"
}

cleanup() {
  local orphan_output
  local -a orphans

  if ! orphan_output=$(pacman -Qtdq); then
    print -u2 'Failed to query orphaned packages.'
    return 1
  fi

  orphans=(${(f)orphan_output})

  if (( ${#orphans} == 0 )); then
    print 'No orphaned packages.'
    return 0
  fi

  sudo pacman -Rsn -- "${orphans[@]}"
}

alias n=ninja
alias c=clear
alias rmpkg='sudo pacman -Rsn'
alias cleanch='sudo pacman -Scc'
alias update='sudo pacman -Syu'
alias apt='man pacman'
alias apt-get='man pacman'
alias please=sudo
alias jctl='journalctl -p 3 -xb'
alias rip='expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

[[ -r /usr/share/doc/pkgfile/command-not-found.zsh ]] &&
  source /usr/share/doc/pkgfile/command-not-found.zsh

# Argcomplete's generated Zsh function is static until argcomplete changes.
_cache_pipx_completion() {
  (( $+commands[register-python-argcomplete] )) || return 0

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache_file="$cache_dir/pipx-completion.zsh"
  local generator="$commands[register-python-argcomplete]"
  local temp_file

  if [[ ! -s "$cache_file" || "$generator" -nt "$cache_file" ]]; then
    mkdir -p -- "$cache_dir" || return 1
    temp_file="$cache_file.$$.tmp"

    if "$generator" --shell zsh pipx >| "$temp_file"; then
      mv -f -- "$temp_file" "$cache_file"
    else
      rm -f -- "$temp_file"
      return 1
    fi
  fi

  source "$cache_file"
}

_cache_pipx_completion
unfunction _cache_pipx_completion

(( $+commands[starship] )) && eval "$(starship init zsh)"

# Syntax highlighting must be sourced after widgets and prompt hooks.
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Local secrets are kept outside the public dotfiles repository.
[[ -r "$HOME/.config/shell/secrets.zsh" ]] && source "$HOME/.config/shell/secrets.zsh"
