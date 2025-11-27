{ pkgs, ... }: {
  users.users.and-rs.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;
  services = {
    spice-autorandr.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

}
