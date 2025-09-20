{ config, pkgs, ... }:

{
  programs.wofi.enable = true;

  xdg.configFile."wofi/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wofi/config";
  xdg.configFile."wofi/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wofi/style.css";
}
