{ pkgs }:
let
  archives = [
    {
      archive = "commit-font.tar.gz.age";
      directory = "commit-font";
      file = ../secrets/fonts/commit-font.tar.gz.age;
    }
    {
      archive = "input-font.tar.gz.age";
      directory = "input-font";
      file = ../secrets/fonts/input-font.tar.gz.age;
    }
    {
      archive = "lucide-icons.tar.gz.age";
      directory = "lucide-icons";
      file = ../secrets/fonts/lucide-icons.tar.gz.age;
    }
    {
      archive = "md-io-font.tar.gz.age";
      directory = "md-io-font";
      file = ../secrets/fonts/md-io-font.tar.gz.age;
    }
    {
      archive = "phosphor-icons.tar.gz.age";
      directory = "phosphor-icons";
      file = ../secrets/fonts/phosphor-icons.tar.gz.age;
    }
    {
      archive = "ocrx-font-otf.tar.gz.age";
      directory = "ocrx-font-otf";
      file = ../secrets/fonts/ocrx-font-otf.tar.gz.age;
    }
    {
      archive = "ocrx-font-ttf.tar.gz.age";
      directory = "ocrx-font-ttf";
      file = ../secrets/fonts/ocrx-font-ttf.tar.gz.age;
    }
  ];

  manifest = pkgs.writeText "private-fonts-manifest" (
    builtins.concatStringsSep "\n" (map (font: "${font.archive}\t${font.directory}") archives) + "\n"
  );

  payload = pkgs.runCommand "private-fonts-encrypted" { } ''
    mkdir -p "$out/share/private-fonts/archives"
    ${builtins.concatStringsSep "\n" (
      map (font: ''
        cp ${font.file} "$out/share/private-fonts/archives/${font.archive}"
      '') archives
    )}
    cp ${manifest} "$out/share/private-fonts/manifest"
  '';

  sync = pkgs.writeShellApplication {
    name = "private-fonts-sync";
    runtimeInputs = with pkgs; [
      age
      coreutils
      fontconfig
      gnutar
      gzip
    ];
    text = ''
      identity="''${PRIVATE_FONTS_IDENTITY:-}"
      font_root="''${PRIVATE_FONTS_DIR:-}"

      while (($#)); do
        case "$1" in
          --identity)
            identity="$2"
            shift 2
            ;;
          --font-root)
            font_root="$2"
            shift 2
            ;;
          *)
            echo "unknown argument: $1" >&2
            exit 2
            ;;
        esac
      done

      if [[ -z "$identity" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
          identity="$HOME/.ssh/agenix-darwin"
        else
          identity="$HOME/.ssh/agenix"
        fi
      fi

      if [[ -z "$font_root" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
          font_root="$HOME/Library/Fonts/PrivateFonts"
        else
          font_root="''${XDG_DATA_HOME:-$HOME/.local/share}/fonts/PrivateFonts"
        fi
      fi

      if [[ ! -r "$identity" ]]; then
        echo "private font identity is not readable: $identity" >&2
        exit 1
      fi

      font_parent="$(dirname "$font_root")"
      mkdir -p "$font_parent"
      stage="$(mktemp -d "$font_parent/.PrivateFonts.XXXXXX")"
      previous=""

      cleanup() {
        [[ -z "$stage" ]] || rm -rf "$stage"
        [[ -z "$previous" ]] || rm -rf "$previous"
      }
      trap cleanup EXIT

      while IFS=$'\t' read -r archive directory; do
        [[ -n "$archive" ]] || continue
        mkdir -p "$stage/$directory"
        age --decrypt \
          --identity "$identity" \
          "${payload}/share/private-fonts/archives/$archive" \
          | tar --extract \
            --gzip \
            --directory "$stage/$directory" \
            --strip-components=1
      done < "${payload}/share/private-fonts/manifest"

      if [[ -e "$font_root" ]]; then
        previous="$font_parent/.PrivateFonts.previous.$$"
        rm -rf "$previous"
        mv "$font_root" "$previous"
      fi

      if ! mv "$stage" "$font_root"; then
        [[ -z "$previous" ]] || mv "$previous" "$font_root"
        previous=""
        exit 1
      fi
      stage=""
      [[ -z "$previous" ]] || rm -rf "$previous"
      previous=""

      if [[ "$(uname -s)" != "Darwin" ]]; then
        fc-cache --force "$font_root"
      fi
    '';
  };

  profileSync = pkgs.writeText "private-fonts-profile-sync" ''
    #!/bin/sh
    set -eu

    profile="''${PRIVATE_FONTS_PROFILE:-/nix/var/nix/profiles/default}"
    font_root="''${PRIVATE_FONTS_DIR:-''${XDG_DATA_HOME:-$HOME/.local/share}/fonts/PrivateFonts}"

    if [ -x "$profile/bin/private-fonts-sync" ]; then
      exec "$profile/bin/private-fonts-sync"
    fi

    rm -rf "$font_root"
    if command -v fc-cache >/dev/null 2>&1; then
      fc-cache --force
    fi
  '';

  profileService = pkgs.writeText "private-fonts-profile-sync.service" ''
    [Unit]
    Description=Synchronize private fonts with the root Nix profile

    [Service]
    Type=oneshot
    ExecStart=%h/.local/libexec/private-fonts-profile-sync
  '';

  profilePath = pkgs.writeText "private-fonts-profile-sync.path" ''
    [Unit]
    Description=Watch the root Nix profile for private font changes

    [Path]
    PathChanged=/nix/var/nix/profiles/per-user/root
    Unit=private-fonts-profile-sync.service

    [Install]
    WantedBy=default.target
  '';

  watchInstaller = pkgs.writeShellApplication {
    name = "private-fonts-profile-watch-install";
    runtimeInputs = with pkgs; [
      coreutils
      systemd
    ];
    text = ''
      if [[ "$(id -u)" == 0 ]]; then
        echo "install the private font profile watcher as the desktop user, not root" >&2
        exit 1
      fi

      install -Dm755 ${profileSync} "$HOME/.local/libexec/private-fonts-profile-sync"
      install -Dm644 ${profileService} "$HOME/.config/systemd/user/private-fonts-profile-sync.service"
      install -Dm644 ${profilePath} "$HOME/.config/systemd/user/private-fonts-profile-sync.path"

      systemctl --user daemon-reload
      systemctl --user enable --now private-fonts-profile-sync.path
      systemctl --user start private-fonts-profile-sync.service
    '';
  };
in
pkgs.symlinkJoin {
  name = "private-fonts";
  paths = [
    payload
    sync
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ watchInstaller ];
}
