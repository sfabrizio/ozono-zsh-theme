source ~/dotfiles/scripts/os_detection.sh

#git values
OZONO_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}\ue709 (%{$fg[red]%}"
OZONO_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
OZONO_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}"
OZONO_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#theme values
OZONO_THEME_NVM_SIMBOL="%{$fg_bold[green]%}⬢"
OZONO_THEME_NVM_PREFIX="%{$fg_bold[green]%}(%{$reset_color%}"
OZONO_THEME_NVM_SUFFIX="%{$fg_bold[green]%})%{$reset_color%}"

#final prompt separator:
# spectrum_ls for see all colors
OZONO_THEME_PROMPT_FINAL="%{$FG[063]%}"'\uf0da '"%{$reset_color%}"

OZONO_THEME_CRASH="💥"
OZONO_THEME_JS_ICON="%{$fg[yellow]%}"$'\ue74e'"%{$reset_color%}"

OZONO_THEME_OK=$'\ue711'
OZONO_THEME_OK_MAC=$'\ue711'
OZONO_THEME_OK_LINUX=$'\ue712'
OZONO_THEME_OK_RASPY=$'\ue722'

#set ok icon according the OS, default mac
if [[ $platform == 'linux' ]]; then
    $OZONO_THEME_OK = $OZONO_THEME_LIMUX
elif [[ $platform == 'raspy' ]]; then
    $OZONO_THEME_OK = $OZONO_THEME_RASPY
fi

#ok or wrong command
local ret_status="%(?:%{$fg_bold[grey]%}$OZONO_THEME_OK:%{$fg_bold[red]%}$OZONO_THEME_CRASH)"

#show nvm current version only when is necessary
function print_nvm_info {
    if command git >/dev/null 2>/dev/null; then
        return
    fi
    local mainPathPackageJson=$(git rev-parse --show-toplevel 2>/dev/null)"/package.json"
    if [[ -f $mainPathPackageJson ]]; then
        local result=""
        result+=$OZONO_THEME_NVM_SIMBOL" "
        result+=$OZONO_THEME_NVM_PREFIX
        result+=%{$fg[yellow]%}$(nvm current)
        result+=$OZONO_THEME_NVM_SUFFIX
        echo "$result"
    fi
}

# Git: branch/detached head, dirty status
prompt_git_status() {
  (( $+commands[git] )) || return
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      echo -n "%{$fg_bold[red]%}"
    else
      echo -n "%{$fg_bold[cyan]%}"
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr "%{$FG[154]%}"'\uf103 '
    zstyle ':vcs_info:*' unstagedstr "%{$FG[197]%}"'\uf0c3 '
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${vcs_info_msg_0_%%}${mode}"
  fi
  echo -n "%{$reset_color%}"
}

#Final prompt concat
PROMPT_OZONO=''
PROMPT_OZONO+='${ret_status}'
PROMPT_OZONO+='  %{$fg[cyan]%}%c%{$reset_color%}'
PROMPT_OZONO+=' $(git_prompt_info)'
PROMPT_OZONO+='$(print_nvm_info)'
PROMPT_OZONO+='$(prompt_git_status)'
PROMPT_OZONO+='$(echo -n $OZONO_THEME_PROMPT_FINAL)'

