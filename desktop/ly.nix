{ ... }: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      colormix_col1 = "0x00ffffff";
      colormix_col2 = "0x00000000";
      colormix_col3 = "0x00000000";

      full_color = true;
      blank_box = true;
      bg = "0x00000000";
      fg = "0x00ffffff";
      error_bg = "0x001b1e25";
      error_fg = "0x00ffc0b9";

      border_fg = "0x00ffffff";
      hide_borders = false;

      margin_box_h = 2;
      margin_box_v = 1;

      hide_key_hints = true;
      hide_version_string = true;
    };
  };
}
