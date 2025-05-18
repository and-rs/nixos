{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./apps/tooling.nix
    ./apps/packages.nix
    ./desktop/wm.nix
    ./desktop/keyd.nix
    ./desktop/tlp.nix
    ./desktop/sddm.nix
    ./desktop/asus.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { and-rs = import ./home-manager/home.nix; };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true;
  zramSwap.enable = true;

  boot.blacklistedKernelModules = [ "nouveau" "sdhci_pci" ];
  boot.kernelParams = [
    "modprobe.blacklist=sdhci_pci"
    "rd.driver.blacklist=nouveau"
    "modprobe.blacklist=nouveau"
    "i915.force_probe=46a6"
    "quite"
    "rhgb"
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      splashImage = null;
      backgroundColor = null;
      theme = pkgs.sleek-grub-theme.override {
        withStyle = "dark";
        withBanner = "";
      };
    };
  };

  networking.hostName = "M16"; # Define your hostname.
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";

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
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users.users.and-rs = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "and-rs";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ steam-run ];
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    noisetorch.enable = true;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    blueman.enable = true;
    openssh.enable = true;
    thermald.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  services.logind = {
    suspendKey = "suspend";
    powerKey = "hibernate";
    hibernateKey = "hibernate";
    lidSwitch = "suspend-then-hibernate";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-media-sdk
      libvdpau-va-gl
      libva-utils
      vpl-gpu-rt
    ];
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "inode/directory" = "nautilus.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };

  system.stateVersion = "24.11"; # do not change at all
}
