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

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # winboat network fixes
  systemd.tmpfiles.rules = [ "d /etc/nftables.d 0755 root root" ];
  environment.etc."nftables.d/dns-nat.conf".text = ''
    add rule ip natfix postrouting ip protocol udp udp dport 53 masquerade
    add rule ip natfix postrouting ip protocol tcp tcp dport 53 masquerade
  '';
}
