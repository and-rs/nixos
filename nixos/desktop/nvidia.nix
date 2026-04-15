{ pkgs, ... }:
{
  systemd.services.nvidia-powerd.enable = false;
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  services.supergfxd.enable = false;
  # environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    dynamicBoost.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
