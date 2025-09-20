{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Key bindings
    prefix = "C-space";

    # Terminal and color support
    terminal = "tmux-256color";

    # Shell config
    shell = "${pkgs.fish}/bin/fish";

    # Window management
    baseIndex = 1;

    # Performance optimisations
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 10000;

    # Input
    mouse = true;
    keyMode = "vi";

    extraConfig = ''
      # Window management - HM doesn't expose this option
      set -g renumber-windows on

      # Status bar styling
      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style "fg=blue,bold"
      set -g status-left-length 25
      set -g status-right "%d %b %y"

      # Terminal color override
      set -ga terminal-overrides ",*256col*:Tc"

      # Config reload
      bind r source-file "~/.tmux.conf"

      # Copy-paste workflow
      bind-key [ copy-mode
      bind-key ] paste-buffer
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
    '';
  };
}
