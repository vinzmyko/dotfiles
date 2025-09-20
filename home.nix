{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/shell.nix
    ./modules/tmux.nix
    ./modules/neovim.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/wofi.nix
    ./modules/qutebrowser.nix
  ];

  home.username = "vinz";
  home.homeDirectory = "/home/vinz";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tree
    fd
    ripgrep
    yazi

    nixd
    nixfmt-rfc-style
    lua-language-server
  ];

  # Create standard dir structure for user files
  home.file = {
    "downloads/.keep".text = "";
    "resources/docs/.keep".text = "";
    "resources/recordings/.keep".text = "";
    "resources/screenshots/.keep".text = "";
    "resources/wallpapers/.keep".text = "";
    "projects/personal/.keep".text = "";
  };

  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/downloads";
  };
}
