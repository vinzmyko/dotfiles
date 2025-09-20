{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };

    shellIntegration.enableFishIntegration = true;

    settings = {
      shell = "fish";
      bold_font = "JetBrainsMono Nerd Font Bold";
      bold_is_bright = true;
      background_opacity = "0.9";
      window_padding_width = 10;
      disable_ligatures = "never";
      confirm_os_window_close = 0;
    };

    extraConfig = builtins.readFile (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty/tokyonight_storm.conf";
        sha256 = "1v0l5ych8x9smbhhbfcs45qsjn2q3cvzy02hmsxx67xgwddcidzy";
      }
    );
  };
}
