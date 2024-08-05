if status is-interactive
  #fish_vi_key_bindings
  #function reverse_history_search
  #history | fzf --no-sort | read -l command
  #if test $command
  #commandline -rb $command
  #end
  #end
  #
  #function fish_user_key_bindings
  #bind -M default / reverse_history_search
  #end
  fish_default_key_bindings
    if command -v flatpak
      alias google-chrome-stable "flatpak run com.google.Chrome"
    else
      alias google-chrome-stable "distrobox-host-exec flatpak run com.google.Chrome"
    end
    alias update "flatpak update -y && distrobox upgrade --all && rpm-ostree update"
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

    # function dbx-create
    #    distrobox-create --name $argv[1] --additional-packages "git neovim bat dnf5 tldr eza helix fastfetch" \
    #                     --volume /var/home/erb/.config/fish:$DBX_CONTAINER_HOME_PREFIX/$argv[1]/.config/fish \
    #                     --volume /var/home/erb/.config/helix:$DBX_CONTAINER_HOME_PREFIX/$argv[1]/.config/helix \
    #                     
    #    distrobox-enter $argv[1]
    # end
end
