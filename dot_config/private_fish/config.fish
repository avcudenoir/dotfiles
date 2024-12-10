if status is-interactive

    fish_add_path /usr/local/bin {$HOME}/.local/bin/
    eval (/opt/homebrew/bin/brew shellenv)

    [ -f ~/.shell_extras_fish.sh ] && source ~/.shell_extras_fish.sh

    fzf --fish | source
    atuin init fish | source
    starship init fish | source
    mise activate fish | source
    direnv hook fish | source

    set -gx EDITOR 'zed --wait'
    set -gx GOPATH "$HOME/go"
    set -gx GOBIN "$HOME/go/bin"
    set -gx GEM_HOME "$HOME/.gems"
    set -gx CARGO_BIN "$HOME/.cargo/bin"

    set -gx AWS_PAGER ""

    set -gx TF_PLUGIN_CACHE_DIR "$HOME/.terraform.d/plugin-cache"
    set -gx TF_PLUGIN_CACHE_MAY_BREAK_DEPENDENCY_LOCK_FILE 1
    set -gx TERRAGRUNT_TFPATH (mise which ~/.local/share/mise/shims/terraform)
    set -gx LC_ALL "pl_PL.UTF-8"
    set -gx LANG "pl_PL.UTF-8"

    set -gx GPG_TTY (tty)

    fish_add_path $GEM_HOME/bin $GOBIN $CARGO_BIN
end
