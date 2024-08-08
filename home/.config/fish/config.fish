if status is-interactive
  fish_default_key_bindings
    if command -v flatpak &> /dev/null
      alias google-chrome-stable "flatpak run com.google.Chrome"
    else
      alias google-chrome-stable "flatpak-spawn --host flatpak run com.google.Chrome"
    end
    if command -v fastfetch &> /dev/null
        fastfetch
    end
    if command -v direnv &> /dev/null
      direnv hook fish | source
    end
    if command -v grc &> /dev/null
      source /etc/grc.fish
    end
    if command -v zellij &> /dev/null
      zellij setup --generate-completion fish | source
    end

    fzf_configure_bindings --directory=\cf
    alias cat "bat --style=plain --theme=\"Dracula\""
    alias ls "eza --icons"
end
