export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.dotnet/tools:/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="mlehmann"
DISABLE_AUTO_TITLE="true"

if command -v brew > /dev/null 2>&1; then
  NVM_HOMEBREW=$(brew --prefix nvm)
fi

plugins=(
  git
  kubectl
  docker
  helm
  terraform
  nvm
  gh
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR="vim"
export ASPNETCORE_ENVIRONMENT=Development
export DOTNET_ENVIRONMENT=Development

function () {
  local dircolors_command="dircolors"
  local df_command="df"

  if [[ $(uname) = 'Darwin' ]]; then
    df_command="gdf"
    dircolors_command="gdircolors"

    # Set and change Java version
    function java-change() {
      echo "---------- Old Java version"
      java -version
      if [ $# -ne 0 ]; then
        export JAVA_HOME=`/usr/libexec/java_home -v $@`
      fi
      echo "---------- New Java version"
      java -version
    }
  else
    ;
  fi

  local dircolors_file="$HOME/source/seebi/dircolors-solarized/dircolors.256dark"
  if [[ -f "${dircolors_file}" ]]; then
    eval $(${dircolors_command} "${dircolors_file}")
  fi

  alias ponyfortune="fortune | ponysay -b unicode"
  alias ponyquote="ponysay -b unicode -q"
  alias pwgen-sec="pwgen -scnyB 20 1"
  alias dfh="${df_command} -h -T"

  autoload zmv
}

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
