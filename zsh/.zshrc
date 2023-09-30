export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.dotnet/tools:/opt/homebrew/opt/openssl@1.1/bin:$PATH"

dircolorsFile="$XDG_CONFIG_HOME/dircolors/dircolors-solarized/dircolors.256dark"
if [[ -f "$dircolorsFile" ]]; then
  if (( $+commands[dircolors] )); then
    eval $(dircolors "$dircolorsFile")
  elif (( $+commands[gdircolors] )); then
    eval $(gdircolors "$dircolorsFile")
  fi
fi

zstyle ':omz:plugins:*' aliases no
zstyle ':omz:plugins:nvm' autoload yes

plugins=(
  terraform
  nvm
)

source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config "$POSH_THEME")"

autoload zmv

# Set and change Java version
function java-change() {
  if [[ "$OSTYPE" = darwin* ]]; then
    echo "---------- Old Java version"
    java -version
    if [ $# -ne 0 ]; then
      export JAVA_HOME=`/usr/libexec/java_home -v $@`
    fi
    echo "---------- New Java version"
    java -version
  else
    echo "The java-change function is only implemented for macOS"
  fi
}

alias ponyfortune="fortune | ponysay -b unicode"
alias ponyquote="ponysay -b unicode -q"
alias pwgen-sec="pwgen -scnyB 20 1"

if (( $+commands[nvim] )); then
  alias vim="nvim"
fi

if (( $+commands[gls])); then
  alias ls="gls --color=auto"
fi

if (( $+commands[duf] )); then
  alias dfh="duf"
elif (( $+commands[gdf] )); then
  alias dfh="gdf -h -T"
else
  alias dfh="df -h -T"
fi

if [[ -f "$XDG_CONFIG_HOME/zsh/.zshrc.local" ]]; then
  source "$XDG_CONFIG_HOME/zsh/.zshrc.local"
fi
