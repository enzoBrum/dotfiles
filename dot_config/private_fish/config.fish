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
    alias firefox "flatpak run org.mozilla.firefox"
    alias google-chrome-stable "flatpak run com.google.Chrome"
    if command -v fastfetch
        fastfetch
    end
    if command -v direnv
      direnv hook fish | source
    end
    if command -v grc
      source /etc/grc.fish
    end
    if command -v fzf
      source /usr/share/fzf/shell/key-bindings.fish
      fzf_key_bindings
    end
    alias cat "bat --style=plain"
    alias ls "eza --icons"

    # function dbx-create
    #    distrobox-create --name $argv[1] --additional-packages "git neovim bat dnf5 tldr eza helix fastfetch" \
    #                     --volume /var/home/erb/.config/fish:$DBX_CONTAINER_HOME_PREFIX/$argv[1]/.config/fish \
    #                     --volume /var/home/erb/.config/helix:$DBX_CONTAINER_HOME_PREFIX/$argv[1]/.config/helix \
    #                     
    #    distrobox-enter $argv[1]
    # end
end
