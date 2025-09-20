{ config, pkgs, ... }:

{
  programs.qutebrowser = {
    enable = true;

    # For better performance and privacy
    package = pkgs.qutebrowser.override {
      enableWideVine = false; # Excludes DRM modules
    };
  };

  # Symlinks
  xdg.configFile."qutebrowser/config.py".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/qutebrowser/config.py";

  xdg.configFile."qutebrowser/greasemonkey".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/qutebrowser/greasemonkey";

  xdg.configFile."qutebrowser/styles".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/qutebrowser/styles";

  home.packages = with pkgs; [
    python3Packages.adblock
  ];
}
