{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    loginShellInit = ''
      # Auto-start Hyprland on login TTY
      if status is-login; and test -z "$DISPLAY"; and test -z "$WAYLAND_DISPLAY"
          exec Hyprland
      end
    '';

    interactiveShellInit = ''
      # Auto-attach tmux if in graphical session
      if test -n "$DISPLAY" -a -z "$TMUX"
          tmux new-session -d -s 0 2>/dev/null
          tmux attach-session -t 0
      end

      # Enable vi mode
      fish_vi_key_bindings

      # Color customisation
      set fish_color_redirection normal
      set fish_color_operator normal
      set fish_greeting ""
    '';

    functions = {
      fish_prompt = ''
        set -l normal (set_color normal)
        set -l cyan (set_color cyan)
        set -l red (set_color red)
        set -l green (set_color green)
        set -l yellow (set_color yellow)

        # Show hostname only if SSH session
        set -l host_info ""
        if set -q SSH_CLIENT; or set -q SSH_TTY
            set host_info (set_color red)"@"(hostname)" "
        end

        set -l pwd_info (set_color cyan)(prompt_pwd)" "

        # Git branch if in git repo
        set -l git_info ""
        if git rev-parse --git-dir >/dev/null 2>&1
            set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null; or echo "main")
            set git_info (set_color yellow)"("$branch") "
        end

        set -l env_info ""
        if set -q IN_NIX_SHELL
            if set -q name
                set env_info (set_color magenta)"{$name} "
            else
                set env_info (set_color magenta)"{nix} "
            end
        end

        echo -n $host_info$env_info$pwd_info$git_info$normal"-> "
      '';
    };
  };
}
