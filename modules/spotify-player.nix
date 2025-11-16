{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify-player
  ];

  # Config goes in ~/.config/spotify-player/app.toml
}
