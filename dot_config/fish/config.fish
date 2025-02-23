if status is-interactive
    if command -v flatpak &> /dev/null
      alias google-chrome-stable "flatpak run com.google.Chrome"
      alias firefox "flatpak run org.mozilla.firefox"
    else
      alias google-chrome-stable "distrobox-host-exec flatpak run com.google.Chrome"
      alias firefox "distrobox-host-exec flatpak run org.mozilla.firefox"
    end 
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
