{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ keyd ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = { main = { capslock = "layer(control)"; }; };
      };
    };
  };

  systemd.services.keyd.serviceConfig = { Group = "wheel"; };
}
