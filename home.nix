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
    ./modules/brave.nix
    ./modules/gammastep.nix
    ./modules/spotify-player.nix
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
    zip
    unzip

    vesktop

    nixd
    nixfmt-rfc-style
    lua-language-server
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Create standard dir structure for user files
  home.file = {
    "downloads/.keep".text = "";
    "notes/.keep".text = "";
    "documents/.keep".text = "";
    "videos/.keep".text = "";
    "pictures/screenshots/.keep".text = "";
    "pictures/wallpapers/.keep".text = "";
    "projects/personal/.keep".text = "";
  };

  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
  };
}
