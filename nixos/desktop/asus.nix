{ pkgs, ... }: {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.extraModprobeConfig = ''
    blacklist spd5118
    options snd_usb_audio implicit_fb=0
    options usbcore autosuspend=-1
  '';

  boot.blacklistedKernelModules = [ "sdhci" "sdhci_pci" "spd5118" ];
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "i915.force_probe=46a6"
    "clocksource=tsc"
    "tsc=reliable"
    "quiet"
  ];

  environment.systemPackages = with pkgs; [ asusctl ];
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  users.groups.power = { };

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
