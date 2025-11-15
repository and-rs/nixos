{ pkgs, inputs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    material-symbols

    # ui fonts
    input-fonts
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

  home.sessionVariables.GTK_THEME = "Colloid-Grey-Dark";

  gtk = {
    enable = true;
    font = {
      name = "Hanken Grotesk";
      size = 10;
    };
    theme = { name = "Colloid-Grey-Dark"; };
    iconTheme = { name = "Papirus-Dark"; };
  };

  qt = { enable = true; };

  programs.spicetify =
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = false;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "frappe";
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
    };
}
