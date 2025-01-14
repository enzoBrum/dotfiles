if status is-interactive
  fish_default_key_bindings
    fastfetch
    direnv hook fish | source
    source /etc/grc.fish
    zellij setup --generate-completion fish | source

    fzf_configure_bindings --directory=\cf
    alias cat "bat --style=plain --theme=\"Dracula\""
    alias ls "eza --icons"

    set -gx PATH $HOME/.local/bin $PATH
end
