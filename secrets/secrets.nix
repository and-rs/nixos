let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTj2/WRs75eDyLPcJzJW5LlZHeS76pbC1HGavRB79bn";
  darwin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1TzsK/VfkieVdyccxlpvyiYLHAM85ZY5yQBosmS5SJ";
in
{
  "hetzner.age".publicKeys = [
    key
    darwin
  ];
}
