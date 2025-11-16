{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.gammastep = {
    enable = true;
    provider = "manual";

    settings = {
      general = {
        # General settings
        fade = lib.mkForce 1;
        transition = lib.mkForce 1;

        # Temperature in Kelvin
        temp-day = lib.mkForce 6500;
        temp-night = lib.mkForce 3700;

        # Brightness adjustment
        brightness-day = lib.mkForce 1.0;
        brightness-night = lib.mkForce 0.85;

        # Gamma correction
        gamma = lib.mkForce "0.8:0.7:1.0";
      };

      manual = {
        lat = 50.9040;
        lon = -1.4043;
      };
    };
  };
}
