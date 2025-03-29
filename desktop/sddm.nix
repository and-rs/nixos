{ pkgs, inputs, system, ... }:
let stable = inputs.stable.legacyPackages.${system};
in {
  environment.systemPackages = with pkgs; [
    stable.where-is-my-sddm-theme
    apple-cursor
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme";
    settings = { Theme = { CursorTheme = "macOS-Monterey"; }; };
  };
}
