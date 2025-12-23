{ pkgs, ... }: {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';
  systemd.services.disable-usb-wakeup = {
    description = "Disable USB wakeup";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        "/bin/sh -c 'echo XHCI > /proc/acpi/wakeup 2>/dev/null || true'";
    };
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.extraModprobeConfig = ''
    blacklist spd5118
  '';
  boot.blacklistedKernelModules = [ "sdhci" "sdhci_pci" "spd5118" ];
  boot.kernelParams = [
    "i915.force_probe=46a6"
    "acpi.debug_layer=0"
    "acpi.debug_level=0"
    "pcie_port_pm=off"
    "clocksource=tsc"
    "tsc=reliable"
    "iommu=soft"
    "quiet"
  ];

  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  services.supergfxd.enable = true;

  environment.systemPackages = with pkgs; [ asusctl ];
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

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
}
