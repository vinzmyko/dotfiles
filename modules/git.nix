{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "vinzmyko";
    userEmail = "vinzmykodelrosario@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      status.short = true;
    };
  };
}
