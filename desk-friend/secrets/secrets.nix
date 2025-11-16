let
  keys = [
    # personal key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPurq4HYYHK0nxukQQAXm9mxlJ2/3plx79z0ckP3q/Q"

    # host ed25519 pubkey
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDohTbLr6SW9DDXekhHDrD+RoKf0u5hyYvuHu9Su+lF7 root@nixos"
  ];
in
{
  "tailscale-authkey.age".publicKeys = keys;
}
