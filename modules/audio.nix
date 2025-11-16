{ config, pkgs, ... }:

{
  # Enable PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # WirePlumber configuration for automatic device switching
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-device-switching.conf" ''
        -- Automatically switch to USB/Bluetooth devices when connected
        -- and back to built-in when disconnected

        rule = {
          matches = {
            {
              { "device.name", "matches", "alsa_card.*" },
            },
          },
          apply_properties = {
            ["device.profile.switch"] = true,
          },
        }

        rule = {
          matches = {
            {
              { "node.name", "matches", "*HyperX*" },
            },
          },
          apply_properties = {
            ["priority.session"] = 2000,
            ["node.pause-on-idle"] = false,
          },
        }
      '')
    ];
  };

  # GUI tools for manual control
  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol # Native PipeWire volume control
  ];
}
