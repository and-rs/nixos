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
      application.not = [
        "com.mitchellh.ghostty"
        "steam_app_813780"
        "xfreerdp"
        "neovide"
        "kitty"
      ];
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
        "A_L-backspace" = [ "Shift-home" "C-x" { set_mark = false; } ];
        "A_L-a" = "C-a";
        "A_L-b" = "C-b";
        "A_L-c" = "C-c";
        "A_L-d" = "C-d";
        "A_L-e" = "C-e";
        "A_L-f" = "C-f";
        "A_L-i" = "C-l";
        "A_L-m" = "C-m";
        "A_L-n" = "C-n";
        "A_L-o" = "C-o";
        "A_L-p" = "C-p";
        "A_L-r" = "C-r";
        "A_L-t" = "C-t";
        "A_L-v" = "C-v";
        "A_L-w" = "C-w";
        "A_L-x" = "C-x";
        "A_L-y" = "C-y";
        "A_L-z" = "C-z";
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
