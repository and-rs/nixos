{ pkgs, lib, ... }:
let
  niriSocketStarter = pkgs.writeShellScript "xremap-niri-starter" ''
    for i in {1..30}; do
      [ -S "$XDG_RUNTIME_DIR"/niri.wayland-*.sock ] && break
      sleep 0.5
    done

    SOCK=$(ls -1 "$XDG_RUNTIME_DIR"/niri.wayland-*.sock 2>/dev/null | head -n1)

    if [ -n "$SOCK" ]; then
      systemctl --user set-environment NIRI_SOCKET="$SOCK"
      systemctl --user start xremap
    fi
  '';
in {
  users.users.and-rs.extraGroups = [ "input" ];

  services.xremap = {
    watch = true;
    enable = true;
    withNiri = true;
    userName = "and-rs";
    serviceMode = "user";

    config.modmap = [{
      name = "caps_ctrl";
      remap = { "CapsLock" = "Ctrl_L"; };
    }];

    config.keymap = [{
      name = "emacs_macos";
      application.not = [ "com.mitchellh.ghostty" ".virt-manager-wrapped" ];
      remap = {
        "C-b" = { with_mark = "left"; };
        "C-f" = { with_mark = "right"; };
        "C-p" = { with_mark = "up"; };
        "C-n" = { with_mark = "down"; };
        "C-a" = { with_mark = "home"; };
        "C-e" = { with_mark = "end"; };
        "C-d" = [ "delete" { set_mark = false; } ];
        "C-k" = [ "Shift-end" "C-x" { set_mark = false; } ];
        "C-u" = [ "Shift-home" "C-x" { set_mark = false; } ];
        "Super-C-b" = { with_mark = "C-left"; };
        "Super-C-f" = { with_mark = "C-right"; };
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
        "Alt-r" = "C-r";
        "Alt-t" = "C-t";
        "Alt-v" = "C-v";
        "Alt-w" = "C-w";
        "Alt-x" = "C-x";
        "Alt-y" = "C-y";
        "Alt-z" = "C-z";
      };
    }];
  };

  systemd.user.services.xremap-niri-starter = {
    description = "Start xremap after Niri with NIRI_SOCKET";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      TimeoutStartSec = "20s";
      ExecStart = "${niriSocketStarter}";
    };
  };

  systemd.user.services.xremap = {
    wantedBy = lib.mkForce [ ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };
}
