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

    config = {
      keypress_delay_ms = 5;

      modmap = [
        {
          name = "caps_ctrl";
          remap = {
            "capslock" = "ctrl_l";
          };
        }
      ];

      keymap = [
        {
          name = "post_select_all_backspace";
          mode = [ "post_select_all" ];
          remap = {
            "alt_l-backspace" = [
              "backspace"
              { set_mode = "default"; }
            ];
            "backspace" = [
              "backspace"
              { set_mode = "default"; }
            ];
          };
        }
        {
          name = "better_chrome_search";
          application.only = [ "helium" ];
          remap = {
            "alt_l-i" = "F6";
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
            "org.pwmt.zathura"
            "Alacritty"
            "xfreerdp"
            "neovide"
            "kitty"
          ];
          remap = {
            "ctrl-b" = "left";
            "ctrl-f" = "right";
            "ctrl-p" = "up";
            "ctrl-n" = "down";
            "ctrl-a" = "home";
            "ctrl-e" = "end";
            "ctrl-d" = "delete";
            "super-ctrl-b" = "ctrl-left";
            "super-ctrl-f" = "ctrl-right";
            "super-backspace" = [ "ctrl-backspace" ];
            "ctrl-k" = [
              "shift-end"
              "ctrl-x"
            ];
            "ctrl-u" = [
              "shift-home"
              "ctrl-x"
            ];
            "alt_l-backspace" = [
              "shift-home"
              "ctrl-x"
            ];
            "alt_l-a" = [
              "ctrl-a"
              { set_mode = "post_select_all"; }
            ];
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
            "alt_l-i" = "ctrl-i";
          };
        }
      ];
    };
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
