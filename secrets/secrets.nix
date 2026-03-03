let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTj2/WRs75eDyLPcJzJW5LlZHeS76pbC1HGavRB79bn";
in
{
  "hetzner-pass.age".publicKeys = [ key ];
}
