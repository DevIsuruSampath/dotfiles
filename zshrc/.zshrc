# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="agnosterzak"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
fzf_cd_widget() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf)
  if [[ -n "$dir" ]]; then
    cd "$dir" || return
    zle reset-prompt
  fi
}

zle -N fzf_cd_widget
bindkey '^f' fzf_cd_widget

# Add to .zshrc - Process kill with fzf (Ctrl+K)
fzf_kill_process() {
  local pid
  pid=$(ps aux | fzf | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    kill -9 "$pid"
    echo "Process $pid killed"
    zle reset-prompt
  fi
}

zle -N fzf_kill_process
bindkey '^k' fzf_kill_process

# Kitty Theme Switcher using fzf with Alt+t shortcut
# Add this to your .zshrc file

# Function for switching Kitty themes using fzf
fzf_kitty_theme() {
  local themes_dir="$HOME/.config/kitty/kitty-themes"
  local config_file="$HOME/.config/kitty/theme.conf"
  
  # Check if themes directory exists
  if [[ ! -d "$themes_dir" ]]; then
    echo "Error: Kitty themes directory not found at $themes_dir"
    zle reset-prompt
    return 1
  fi
  
  # Use find to locate all theme files and pipe to fzf
  local selected_theme=$(find "$themes_dir" -type f | fzf --preview "cat {}" --height 40% --border)
  
  # If user selected a theme, apply it
  if [[ -n "$selected_theme" ]]; then
    # Create symlink to the selected theme
    ln -sf "$selected_theme" "$config_file"
    
    # Display the selected theme name
    echo "Theme changed to: $(basename "$selected_theme")"
    
    # Reload Kitty configuration
    kill -SIGUSR1 $(pidof kitty)
  fi
  
  # Reset the prompt
  zle reset-prompt
}

# Register as ZLE widget and bind to Alt+t
zle -N fzf_kitty_theme
bindkey '^[t' fzf_kitty_theme  # Alt+t
