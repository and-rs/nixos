{ pkgs, inputs, ... }:
{
  # yt-dlp setup to override my network block
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "yt-dlp" ''
      set -e
      REAL_RESOLV=$(${pkgs.coreutils}/bin/readlink -f /etc/resolv.conf)
      DNS_FILE=$(mktemp)
      echo "nameserver 1.1.1.1" > "$DNS_FILE"
      echo "nameserver 8.8.8.8" >> "$DNS_FILE"
      trap "rm -f $DNS_FILE" EXIT
      echo "Bypassing DNS (Target: $REAL_RESOLV, Masking: nscd)..."
      exec ${pkgs.bubblewrap}/bin/bwrap \
        --dev-bind / / \
        --bind "$DNS_FILE" "$REAL_RESOLV" \
        --tmpfs /run/nscd \
        -- ${pkgs.yt-dlp}/bin/yt-dlp "$@"
    '')

    inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
    imagemagick
    fastfetch
    hyperfine
    alacritty
    cbonsai
    neovide
    cmatrix
    ripgrep
    zoxide
    direnv
    slides
    tokei
    unzip
    delta
    p7zip
    kitty
    yazi
    btop
    stow
    tmux
    wget
    nmap
    tldr
    git
    eza
    bat
    fzf
    zsh
    fd
    gh
    jq
  ];
}
