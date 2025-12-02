{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./modules/audio.nix ];

  # Boot Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # System Identity & Networking
  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  # ThinkPad 480 Specific
  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
  services.fstrim.enable = true; # Keeps SSD healthy
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Less aggressive swapping
    "fs.inotify.max_user_watches" = 524288; # For file watchers in dev tools
  };

  # Never suspend on lid close, manual suspend only
  services.logind = {
    lidSwitch = "ignore";
  };

  # Regional Settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Dark Theme Config
  programs.dconf.enable = true;
  environment.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    }
  ];

  # Desktop Environment & Input
  programs.hyprland.enable = true;
  services.libinput.enable = true;

  # User Configuration
  users.users.vinz = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  # Automatically start fish hack
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] 
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # System Programs & Services
  services.fwupd.enable = true; # Firmware update service
  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      # Workaround for HyperX Cloud III headset - use 16-bit/48 kHz
      extraConfig = {
        "51-hyperx-cloud-iii" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = "~alsa_output.usb-HP__Inc_HyperX_Cloud_III_S_Wireless.*";
                }
              ];
              actions = {
                update-props = {
                  "audio.format" = "S16LE";
                  "audio.rate" = 48000;
                };
              };
            }
          ];
        };
      };
    };
  };

  # Fonts & Appearance
  fonts.packages = with pkgs; [
    cascadia-code
    nerd-fonts.jetbrains-mono
  ];

  # System Packages
  environment.systemPackages = with pkgs; [
    gcc
    # Put docker settings here for now, move to podman in development.nix files later
    # development.nix cannot set virtualisation.docker.enable and add to groups
    docker
    docker-compose
    wl-clipboard
    adwaita-icon-theme
  ];

  virtualisation.docker.enable = true;

  # Nix Configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05";
}
