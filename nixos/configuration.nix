{ pkgs, inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./networking/blocklist.nix
    ./networking/networkd.nix

    ./apps/terminal-linux.nix
    ./apps/tooling-linux.nix
    ./apps/packages.nix

    ./desktop/directories.nix
    ./desktop/environment.nix
    ./desktop/libvirt.nix
    ./desktop/xremap.nix
    ./desktop/nvidia.nix
    ./desktop/fonts.nix
    ./desktop/asus.nix
    ./desktop/tlp.nix
    ./desktop/ly.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { and-rs = import ./home-manager/home.nix; };
  };

  zramSwap.enable = true;

  boot.loader = {
    systemd-boot = {
      enable = true;
      windows = { "11-home".efiDeviceHandle = "HD1b"; };
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = false;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";

  time.hardwareClockInLocalTime = true;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  users.users.and-rs = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "and-rs";
    extraGroups = [ "wheel" "docker" ];
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    noisetorch.enable = true;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    thermald.enable = true;
    gnome.gnome-keyring.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleSuspendKey = "suspend";
      HandleLidSwitch = "suspend-then-hibernate";
    };
  };

  system.stateVersion = "25.05"; # do not change at all
}
