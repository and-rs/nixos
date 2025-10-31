{ ... }: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      colormix_col1 = "0x0008";
      colormix_col2 = "0x0008";
      colormix_col3 = "0x0001";

      full_color = true;
      blank_box = true;
      bg = "0x0008";
      fg = "0x0001";
      error_bg = "0x0008";
      error_fg = "0x0002";

      border_fg = "0x0101";
      hide_borders = false;

      margin_box_h = 2;
      margin_box_v = 1;

      hide_key_hints = true;
      hide_version_string = true;
    };
  };
}
