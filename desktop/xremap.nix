{
  services.xremap = {
    watch = true;
    # debug = true;
    enable = true;
    withNiri = true;
  };

  services.xremap.config.modmap = [{
    name = "caps_ctrl";
    remap = { "CapsLock" = "Ctrl_L"; };
  }];

  services.xremap.config.keymap = [{
    name = "emacs_macos";
    application.not = "/com.mitchellh.ghostty/";
    remap = {
      "C-b" = { with_mark = "left"; };
      "C-f" = { with_mark = "right"; };
      "C-p" = { with_mark = "up"; };
      "C-n" = { with_mark = "down"; };
      "M-b" = { with_mark = "C-left"; };
      "M-f" = { with_mark = "C-right"; };
      "C-a" = { with_mark = "home"; };
      "C-e" = { with_mark = "end"; };
      "C-d" = [ "delete" { set_mark = false; } ];
      "C-k" = [ "Shift-end" "C-x" { set_mark = false; } ];
      "C-u" = [ "Shift-home" "C-x" { set_mark = false; } ];
      "Super-backspace" = [ "C-backspace" { set_mark = false; } ];
      "Alt-a" = "C-a";
      "Alt-b" = "C-b";
      "Alt-c" = "C-c";
      "Alt-d" = "C-d";
      "Alt-e" = "C-e";
      "Alt-f" = "C-f";
      "Alt-i" = "C-l";
      "Alt-m" = "C-m";
      "Alt-n" = "C-n";
      "Alt-o" = "C-o";
      "Alt-p" = "C-p";
      "Alt-q" = "C-q";
      "Alt-r" = "C-r";
      "Alt-s" = "C-s";
      "Alt-t" = "C-t";
      "Alt-u" = "C-u";
      "Alt-v" = "C-v";
      "Alt-w" = "C-w";
      "Alt-x" = "C-x";
      "Alt-y" = "C-y";
      "Alt-z" = "C-z";
    };
  }];
}
