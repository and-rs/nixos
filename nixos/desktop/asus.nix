{ pkgs, lib, config, ... }: {

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vulkan-loader
      libva-utils
      vpl-gpu-rt
    ];
  };

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    dynamicBoost.enable = lib.mkDefault true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" "sdhci" "sdhci_pci" ];
  boot.kernelParams = [ "i915.force_probe=46a6" "quiet" ];

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  systemd.services.nvidia-powerd.enable = false;
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  environment.systemPackages = with pkgs; [ asusctl supergfxctl ];
}
