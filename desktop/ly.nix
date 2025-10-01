{ config, pkgs, lib, ... }: {
  services.displayManager.ly.enable = true;

  environment.etc."ly/config.ini" = lib.mkForce {
    text = ''
      path=${pkgs.coreutils}/bin:${pkgs.systemd}/bin
      restart_cmd=${config.systemd.package}/bin/systemctl reboot
      service_name=ly
      setup_cmd=${pkgs.xorg.xorgserver}/bin/xinit
      shutdown_cmd=${config.systemd.package}/bin/systemctl poweroff
      term_reset_cmd=${pkgs.ncurses}/bin/tput reset
      term_restore_cursor_cmd=${pkgs.ncurses}/bin/tput cnorm
      tty=1
      waylandsessions=${config.services.displayManager.sessionData.desktops}/share/wayland-sessions
      x_cmd=
      xauth_cmd=
      xsessions=${config.services.displayManager.sessionData.desktops}/share/xsessions

      allow_empty_password = true
      animation = matrix
      asterisk = *
      auth_fails = 10
      bg = 0x07090D
      bigclock = en
      bigclock_12hr = false
      bigclock_seconds = false
      blank_box = true
      border_fg = 0x07090D
      box_title = null
      clear_password = true
      cmatrix_fg = 0x07090D
      cmatrix_head_col = 0xCACACA
      error_bg = 0x00000000
      error_fg = 0x01FF0000
      fg = 0x00FFFFFF
      full_color = true
      hide_borders = true
      hide_version_string = true
      hide_key_hints = true
    '';
  };
}
