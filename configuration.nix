{ pkgs, inputs, system, ... }:
let stable = inputs.stable.legacyPackages.${system};
in {
  imports = [
    ./hardware-configuration.nix
    ./tooling.nix
    ./packages.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { dagger = import ./home-manager/home.nix; };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelParams = [
    "rd.driver.blacklist=nouveau"
    "modprobe.blacklist=nouveau"
    "rhgb"
    "quite"
  ];

  boot.loader.grub = {
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

  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "killer";
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

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    synaptics.enable = false;
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;
  };

  environment.systemPackages = with pkgs; [
    stable.where-is-my-sddm-theme
    apple-cursor
  ];

  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme";
    settings = { Theme = { CursorTheme = "macOS-Monterey"; }; };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  users.users.dagger = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "dagger";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox ];
  };

  programs = {
    nm-applet.enable = true;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
    dconf.enable = true;
    zsh.enable = true;
  };

  services.logind = {
    powerKey = "suspend";
    suspendKey = "suspend";
    hibernateKey = "suspend";
    lidSwitch = "suspend";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_MAX_PERF_ON_BAT = 30;
      RUNTIME_PM_ON_BAT = "auto";
      PCIE_ASPM_ON_BAT = "powersupersave";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    QT_SCREEN_SCALE_FACTORS = "1.5";
  };

  services = {
    gnome.gnome-keyring.enable = true;
    supergfxd.enable = true;
    thermald.enable = true;
    blueman.enable = true;
    openssh.enable = true;

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
  };

  system.stateVersion = "24.05";
}
