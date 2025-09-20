{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ];

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

  # Fonts & Appearance
  fonts.packages = with pkgs; [
    cascadia-code
    nerd-fonts.jetbrains-mono
  ];

  # System Packages
  environment.systemPackages = with pkgs; [
    gcc
    wl-clipboard
    adwaita-icon-theme
  ];

  # Nix Configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.05";
}
