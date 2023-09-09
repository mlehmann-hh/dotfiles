MLEHMANN_THEME_NODE_PROMPT_PREFIX=" %B%F{green}%f%b "
MLEHMANN_THEME_NODE_PROMPT_SUFFIX=" "

MLEHMANN_THEME_PYTHON_PROMPT_PREFIX=" %B%F{blue}%f%b "
MLEHMANN_THEME_PYTHON_PROMPT_SUFFIX=" "

MLEHMANN_THEME_JAVA_PROMPT_PREFIX=" %B%F{208}%f%b "
MLEHMANN_THEME_JAVA_PROMPT_SUFFIX=" "

MLEHMANN_THEME_K8S_PROMPT_PREFIX=" %B%F{cyan}k8s%f%b "
MLEHMANN_THEME_K8S_PROMPT_SUFFIX=" "

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_CLEAN=" %B%F{green}✓%f%b"
ZSH_THEME_GIT_PROMPT_DIRTY=" %B%F{yellow}●%f%b"
ZSH_THEME_GIT_PROMPT_AHEAD=" %F{cyan}%f"
ZSH_THEME_GIT_PROMPT_BEHIND=" %F{magenta}%f"
ZSH_THEME_GIT_PROMPT_DIVERGED=" %F{red}%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED= #" %F{cyan}✭%f"
ZSH_THEME_GIT_PROMPT_ADDED= #" %F{green}✚%f"
ZSH_THEME_GIT_PROMPT_MODIFIED= #" %F{blue}✹%f"
ZSH_THEME_GIT_PROMPT_RENAMED= #" %F{magenta}➜%f"
ZSH_THEME_GIT_PROMPT_DELETED= #" %F{red}✖%f"
ZSH_THEME_GIT_PROMPT_UNMERGED= #" %F{yellow}═%f"
ZSH_THEME_GIT_PROMPT_STASHED=

VIRTUAL_ENV_DISABLE_PROMPT=1

mlehmann_exists() {
  command -v "$1" > /dev/null 2>&1
}

mlehmann_prompt_strlen() {
  local invisible='%([BSUbfksu]|([FK]|){*})'
  local arg=$1
  local visible=${(S%%)arg//$~invisible/}
  local strlen=${#visible}
  echo $strlen
}

mlehmann_line_spacer() {
  local text_length=$(mlehmann_prompt_strlen "$1")
  local padding_char="${2:- }"
  ((spacer_length=COLUMNS - text_length - 1))
  local spacer=""

  for i in {0..$spacer_length}; do
    spacer="${spacer}${padding_char}"
  done

  echo "$spacer"
}

mlehmann_node_prompt() {
  local node_version

  if (( ${+MLEHMANN_THEME_NODE_PROMPT_DISABLED} )); then
    return
  fi

  if mlehmann_exists nvm; then
    node_version=$(nvm current 2> /dev/null)
  fi

  if [[ "${node_version:-system}" == "system" ]] && mlehmann_exists node; then
    node_version=$(node -v 2> /dev/null)
  fi

  if [[ -z "$node_version" ]]; then
    return
  fi

  node_version="$(echo "$node_version" | awk -F '[v.]' '{ print $2 "." $3 }')"

  if [[ -n ${node_version} ]]; then
    echo "${MLEHMANN_THEME_NODE_PROMPT_PREFIX}${node_version}${MLEHMANN_THEME_NODE_PROMPT_SUFFIX}"
  else
    return
  fi
}

mlehmann_python_prompt() {
  local python_version

  if (( ${+MLEHMANN_THEME_PYTHON_PROMPT_DISABLED} )); then
    return
  elif mlehmann_exists python; then
    python_version="$(python -V)"
  elif mlehmann_exists python3; then
    python_version="$(python3 -V)"
  else
    return
  fi

  python_version="$( echo "$python_version" | awk -F '[ .]' '{print $2 "." $3}')"

  local venv_name=""
  if [[ -n $VIRTUAL_ENV ]]; then
    venv_name=" ($(basename "$VIRTUAL_ENV" ))"
  fi

  if [[ -n ${python_version} ]]; then
    echo "${MLEHMANN_THEME_PYTHON_PROMPT_PREFIX}${python_version}${venv_name}${MLEHMANN_THEME_PYTHON_PROMPT_SUFFIX}"
  else
    return
  fi
}

mlehmann_java_prompt() {
  local java_version

  if (( ${+MLEHMANN_THEME_JAVA_PROMPT_DISABLED} )); then
    return
  elif mlehmann_exists java; then
    java_version="$(java -version 2>&1 | head -n 1)"
  else
    return
  fi

  local major_version="$(echo "$java_version" | awk -F '["_.]' '{ print $2 }')"
  local minor_version="$(echo "$java_version" | awk -F '["_.]' '{ print $3 }')"

  if [[ "$major_version" == "1" ]]; then
    java_version="${major_version}.${minor_version}"
  else
    java_version="${major_version}"
  fi

  if [[ -n ${java_version} ]]; then
    echo "${MLEHMANN_THEME_JAVA_PROMPT_PREFIX}${java_version}${MLEHMANN_THEME_JAVA_PROMPT_SUFFIX}"
  else
    return
  fi
}

mlehmann_kube_prompt() {
  local kube_context

  if (( ${+MLEHMANN_THEME_K8S_PROMPT_DISABLED} )); then
    return
  elif mlehmann_exists kubectl; then
    kube_context="$(kubectl config current-context 2> /dev/null)"
  else
    return
  fi

  if [[ -n ${kube_context} ]]; then
    echo "${MLEHMANN_THEME_K8S_PROMPT_PREFIX}${kube_context}${MLEHMANN_THEME_K8S_PROMPT_SUFFIX}"
  else
    return
  fi
}

mlehmann_line1_prompt() {
  local node_prompt="$(mlehmann_node_prompt)"
  local python_prompt="$(mlehmann_python_prompt)"
  local java_prompt="$(mlehmann_java_prompt)"
  local kube_prompt="$(mlehmann_kube_prompt)"
  
  echo "${kube_prompt}──${java_prompt}──${python_prompt}──${node_prompt}─"
}

mlehmann_line2_prompt_left() {
  local username="%B%(!.%F{red}%n%f.%F{white}%n%f)%b"
  
  local hostname=""
  if [[ -n $SSH_CONNECTION ]]; then
    hostname="@%m"
  fi

  # TODO: Truncate path to fit - see jonathan.zsh-theme
  echo " ${username}${hostname} %~"
}

mlehmann_line2_prompt_right() {
  echo " %D{%R} "
}

mlehmann_line3_prompt_left() {
  local last_status="%(?..%F{red}✘%f )"
  local bg_jobs="%(1j.%F{cyan}⚙%f .)"
  local liberty='%(!.%F{red}#%f.%F{green}%f) '
  echo " ${last_status}${bg_jobs}> ${liberty}"
}

mlehmann_line3_prompt_right() {
  git_prompt_info
}

mlehmann_precmd() {
  local line1_text="$(mlehmann_line1_prompt)"
  local line1_spacer=$(mlehmann_line_spacer "xxx${line1_text}" "─")

  local line2_left="$(mlehmann_line2_prompt_left)"
  local line2_right="$(mlehmann_line2_prompt_right)"
  local line2_spacer=$(mlehmann_line_spacer "xxxx${line2_left}${line2_right}")

  print
  print -rP "╭${line1_spacer}${line1_text}╮"
  print -rP "│${line2_left}${line2_spacer}${line2_right}─┤"
}

setopt prompt_subst
PROMPT='╰─$(mlehmann_line3_prompt_left)'
RPROMPT='$(mlehmann_line3_prompt_right)─╯'

autoload -U add-zsh-hook
add-zsh-hook precmd mlehmann_precmd
