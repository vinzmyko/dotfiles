{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprpaper
    grim # Screenshots
    slurp # Screen selection
    wf-recorder # Screen recording
    brightnessctl # Brightness control
    playerctl # Media control
  ];

  # Symlink Hyprland configuration for live editing
  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hyprland.conf";

  # Hyprpaper configuration
  xdg.configFile."hypr/hyprpaper.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hyprpaper.conf";
}
