{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    material-symbols

    # ui fonts
    hanken-grotesk
    recursive

    papirus-icon-theme
    papirus-folders

    (colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "grey" ];
      tweaks = [ "black" ];
    })
  ];

  xresources.extraConfig = "Xft.dpi: 196";
  home.sessionVariables.GTK_THEME = "Colloid-Grey-Dark";

  gtk = {
    enable = true;
    font = {
      name = "Hanken Grotesk";
      size = 10;
    };
    theme = {
      name = "Colloid-Grey-Dark";
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
  };

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = false;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
        shuffle
      ];
    };

  qt = {
    enable = true;
  };
}
