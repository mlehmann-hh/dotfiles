export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.dotnet/tools:/opt/homebrew/opt/openssl@1.1/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_THEME=""
export DISABLE_AUTO_TITLE="true"

export POSH_THEME="$XDG_CONFIG_HOME/oh-my-posh/theme.omp.yaml"

export NVM_DIR="$XDG_CONFIG_HOME/nvm"

export EDITOR="vim"
export PAGER="less"
export LESS="-R"
export ASPNETCORE_ENVIRONMENT=Development
export DOTNET_ENVIRONMENT=Development

if type brew &> /dev/null; then
  export FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi
export FPATH="$HOME/.config/zsh/site-functions:$FPATH"
