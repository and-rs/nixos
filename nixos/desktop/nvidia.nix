{ ... }: {
  # never comment these lines
  # nouveau should always be blacklisted
  # nvidia-powerd should always be disabled with or without nvidia support
  systemd.services.nvidia-powerd.enable = false;
  boot.blacklistedKernelModules =
    [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  # disabling the nvidia gpu
  services.supergfxd.enable = false;
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';

  # services.supergfxd.enable = true;
  # systemd.services.supergfxd.path = [ pkgs.pciutils ];
  # environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];
  # services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  # hardware.nvidia = {
  #   open = true;
  #   nvidiaSettings = true;
  #   modesetting.enable = true;
  #   dynamicBoost.enable = true;
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = true;
  #   prime = {
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  #   prime.offload = {
  #     enable = true;
  #     enableOffloadCmd = true;
  #   };
  # };
}
