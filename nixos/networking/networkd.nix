{
  services.resolved.enable = true;
  services.tailscale.enable = true;

  systemd.network.networks = {
    "40-wired" = {
      matchConfig.Name = "eno2";
      networkConfig.DHCP = "yes";
    };
    "40-wireless" = {
      matchConfig.Name = "wlan0";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
    };
    "50-tailscale" = {
      matchConfig.Name = "tailscale0";
      linkConfig.RequiredForOnline = "no";
    };
  };

  networking = {
    useDHCP = false;
    hostName = "M16";
    useNetworkd = true;
    wireless.iwd.enable = true;
    networkmanager.enable = false;
    firewall = {
      enable = true;
      allowedUDPPorts = [ 2300 ];
    };
  };
}
