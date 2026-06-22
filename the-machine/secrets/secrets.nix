# based on https://www.splitbrain.org/blog/2025-07/27-agenix
let
  keys = [
    # /root/.ssh/id_ed25519.pub
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMBcUZ1wDWg1TQPu1LcNyqiiXtrA5zUJUoc/jgI7DE0V the-machine root user"

    # personal key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPurq4HYYHK0nxukQQAXm9mxlJ2/3plx79z0ckP3q/Q"
  
    # the-machine ed-25519 host key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCkC850y/Bj7S9hV5B7etnFRvDCBQAo4+3n3SCRzEyd root@the-machine"
  ];
in
{
  "tailscale-authkey.age".publicKeys = keys;
}
