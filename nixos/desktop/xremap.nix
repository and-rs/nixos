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
in
{
  users.users.and-rs.extraGroups = [ "input" ];

  services.xremap = {
    watch = true;
    enable = true;
    withNiri = true;
    userName = "and-rs";
    serviceMode = "user";

    config.modmap = [
      {
        name = "caps_ctrl";
        remap = {
          "capslock" = "ctrl_l";
        };
      }
    ];

    config.keymap = [
      {
        name = "better_chrome_search";
        application.only = [ "helium" ];
        remap = {
          "alt_l-i" = "ctrl-shift-a";
          "alt_l-shift-i" = "ctrl-l";
        };
      }
      {
        name = "wheres_my_tilde";
        remap = {
          "alt-apostrophe" = "grave";
        };
      }
      {
        name = "emacs_macos";
        application.not = [
          "com.mitchellh.ghostty"
          "steam_app_813780"
          "Alacritty"
          "xfreerdp"
          "neovide"
          "kitty"
        ];
        remap = {
          "ctrl-b" = {
            with_mark = "left";
          };
          "ctrl-f" = {
            with_mark = "right";
          };
          "ctrl-p" = {
            with_mark = "up";
          };
          "ctrl-n" = {
            with_mark = "down";
          };
          "ctrl-a" = {
            with_mark = "home";
          };
          "ctrl-e" = {
            with_mark = "end";
          };
          "ctrl-d" = [
            "delete"
            { set_mark = false; }
          ];
          "ctrl-k" = [
            "shift-end"
            "ctrl-x"
            { set_mark = false; }
          ];
          "ctrl-u" = [
            "shift-home"
            "ctrl-x"
            { set_mark = false; }
          ];
          "super-ctrl-b" = {
            with_mark = "ctrl-left";
          };
          "super-ctrl-f" = {
            with_mark = "ctrl-right";
          };
          "super-backspace" = [
            "ctrl-backspace"
            { set_mark = false; }
          ];
          "alt_l-backspace" = [
            "shift-home"
            "ctrl-x"
            { set_mark = false; }
          ];
          "alt_l-a" = "ctrl-a";
          "alt_l-b" = "ctrl-b";
          "alt_l-c" = "ctrl-c";
          "alt_l-d" = "ctrl-d";
          "alt_l-e" = "ctrl-e";
          "alt_l-f" = "ctrl-f";
          "alt_l-m" = "ctrl-m";
          "alt_l-n" = "ctrl-n";
          "alt_l-o" = "ctrl-o";
          "alt_l-p" = "ctrl-p";
          "alt_l-r" = "ctrl-r";
          "alt_l-t" = "ctrl-t";
          "alt_l-v" = "ctrl-v";
          "alt_l-w" = "ctrl-w";
          "alt_l-x" = "ctrl-x";
          "alt_l-y" = "ctrl-y";
          "alt_l-z" = "ctrl-z";
        };
      }
    ];
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
