{ config, pkgs, lib, ... }: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      allow_empty_password = true;
      animation = "none";
      asterisk = "*";
      auth_fails = 10;
      bg = "0x07090D";
      bigclock = "en";
      bigclock_12hr = false;
      bigclock_seconds = false;
      blank_box = true;
      border_fg = "0x07090D";
      box_title = "null";
      clear_password = true;
      cmatrix_fg = "0x07090D";
      cmatrix_head_col = "0xCACACA";
      error_bg = "0x00000000";
      error_fg = "0x01FF0000";
      fg = "0x00FFFFFF";
      full_color = true;
      hide_borders = true;
      hide_version_string = true;
      hide_key_hints = true;
    };
  };
}
