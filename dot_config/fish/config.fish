if status is-interactive
    fish_default_key_bindings
    fastfetch
    direnv hook fish | source
    source /etc/grc.fish
    if command -v zellij &> /dev/null
      zellij setup --generate-completion fish | source
    end

    fzf_configure_bindings --directory=\cf
    alias cat "bat --style=plain --theme=\"Dracula\""
    alias ls "eza --icons"

    set -gx PATH $HOME/.local/bin $PATH
    set -gx DBX_CONTAINER_IMAGE localhost/my-toolbox
    set -fx DISTROBOX__HOME /var/home/erb/containers
    set -gx EDITOR nvim
end
