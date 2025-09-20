{ config, pkgs, ... }:

{
  programs.neovim.enable = true;

  # Symlink
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/config/nvim";
}
