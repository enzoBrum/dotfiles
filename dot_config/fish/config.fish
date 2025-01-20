if status is-interactive
    if command -v flatpak &> /dev/null
      alias google-chrome-stable "flatpak run com.google.Chrome"
    else
      alias google-chrome-stable "distrobox-host-exec flatpak run com.google.Chrome"
    end fish_default_key_bindings

    fastfetch
    direnv hook fish | source
    source /etc/grc.fish
    zellij setup --generate-completion fish | source

    fzf_configure_bindings --directory=\cf
    alias cat "bat --style=plain --theme=\"Dracula\""
    alias ls "eza --icons"

    set -gx PATH $HOME/.local/bin $PATH
    set -gx DBX_CONTAINER_IMAGE my-toolbox
    set -fx DISTROBOX__HOME /var/home/erb/containers
end
