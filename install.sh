#!/usr/bin/env bash
# I took this install script from another nice zsh theme: https://github.com/denysdovhan/spaceship-zsh-theme
# I just change it a litte bit.

# load oh-my-zsh variables
source "$HOME/.zshrc"

# script values
REMOTE='https://raw.githubusercontent.com/sfabrizio/ozono-zsh-theme/master/ozono-theme.zsh'
THEME_DIR="$ZSH_CUSTOM/themes/ozono.zsh-theme"
THEME_NAME='ozono'


# Red bold error
function error() {
  echo
  echo "$fg_bold[red]Error: $* $reset_color"
  echo
}

# Green bold message
function message() {
  echo
  echo "$fg_bold[green]Message: $* $reset_color"
  echo
}

# If themes folder isn't exist, then make it
[ -d $ZSH_CUSTOM/themes ] || mkdir $ZSH_CUSTOM/themes

# Download theme from repo
if $(command -v curl >/dev/null 2>&1); then
  # Using curl
  curl -o $THEME_DIR $REMOTE || { error "Filed!" ; return }
elif $(command -v wget >/dev/null 2>&1); then
  # Using wget
  wget -O $THEME_DIR $REMOTE || { error "Filed!" ; return }
else
  # Exit with error
  error "curl and wget are unavailable!"
  exit 1
fi

# Replace current theme with the right onw
sed -i "s/ZSH_THEME='.*'/ZSH_THEME='$THEME_NAME'/g" "$HOME/.zshrc" \
|| error "Cannot change theme in ~/.zshrc. Please, do it by yourself." \
&& message "Done! $THEME_NAME is intalled. Please, reload your terminal."
