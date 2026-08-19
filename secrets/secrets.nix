let
  nixosKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTj2/WRs75eDyLPcJzJW5LlZHeS76pbC1HGavRB79bn";
  darwinKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1TzsK/VfkieVdyccxlpvyiYLHAM85ZY5yQBosmS5SJ";
  amadeusKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7i1HdPX0AOh7yjgmrpm+1wICTJxDF54jXm6EkGajh3 amadeus-private-fonts";

  infrastructureRecipients = [
    nixosKey
    darwinKey
  ];
  fontRecipients = infrastructureRecipients ++ builtins.filter (key: key != "") [ amadeusKey ];
in
{
  "hetzner.age".publicKeys = infrastructureRecipients;
  "fonts/commit-font.tar.gz.age".publicKeys = fontRecipients;
  "fonts/input-font.tar.gz.age".publicKeys = fontRecipients;
  "fonts/lucide-icons.tar.gz.age".publicKeys = fontRecipients;
  "fonts/md-io-font.tar.gz.age".publicKeys = fontRecipients;
  "fonts/phosphor-icons.tar.gz.age".publicKeys = fontRecipients;
  "fonts/ocrx-font-ttf.tar.gz.age".publicKeys = fontRecipients;
  "fonts/ocrx-font-otf.tar.gz.age".publicKeys = fontRecipients;
}
