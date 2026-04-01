let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTj2/WRs75eDyLPcJzJW5LlZHeS76pbC1HGavRB79bn";
  darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1TzsK/VfkieVdyccxlpvyiYLHAM85ZY5yQBosmS5SJ";
  allKeys = [
    key
    darwin
  ];
in
{
  "hetzner.age".publicKeys = allKeys;
  "fonts/commit-font.tar.gz.age".publicKeys = allKeys;
  "fonts/hermit-font.tar.gz.age".publicKeys = allKeys;
  "fonts/input-font.tar.gz.age".publicKeys = allKeys;
  "fonts/lucide-icons.tar.gz.age".publicKeys = allKeys;
  "fonts/phosphor-icons.tar.gz.age".publicKeys = allKeys;
  "fonts/ocrx-font-ttf.tar.gz.age".publicKeys = allKeys;
  "fonts/ocrx-font-otf.tar.gz.age".publicKeys = allKeys;
}
