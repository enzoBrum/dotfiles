if status is-interactive
  fish_default_key_bindings
    if command -v flatpak
      alias google-chrome-stable "flatpak run com.google.Chrome"
    else
      alias google-chrome-stable "distrobox-host-exec flatpak run com.google.Chrome"
    end
    if command -v fastfetch
        fastfetch
    end
    if command -v direnv
      direnv hook fish | source
    end
    if command -v grc
      source /etc/grc.fish
    end

    fzf_configure_bindings --directory=\cf
    alias cat "bat --style=plain --theme=\"Dracula\""
    alias ls "eza --icons"
end
