### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

## コマンド補完
zinit ice wait!'0'; zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

## シンタックスハイライト
zinit light zsh-users/zsh-syntax-highlighting

## 履歴補完
zinit light zsh-users/zsh-autosuggestions

# 補完の色を変える
zinit light chrissicool/zsh-256color

## anyframe
zinit light mollifier/anyframe

# peco でコマンドの実行履歴を表示
bindkey '^R' anyframe-widget-execute-history

# peco でディレクトリの移動履歴を表示
bindkey '^e' anyframe-widget-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# branch一覧をインクリメントサーチ & checkout
bindkey '^B' anyframe-widget-checkout-git-branch

# GHQでクローンしたGitリポジトリを表示
function peco-ghq-look () {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  local ghq_root=$(ghq root)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${ghq_root}/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-ghq-look
bindkey '^G' peco-ghq-look

## starship
zinit light spaceship-prompt/spaceship-prompt

SPACESHIP_TIME_SHOW=true
SPACESHIP_CHAR_SYMBOL="> "
