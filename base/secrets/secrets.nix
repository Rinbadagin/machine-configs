let
  keys = [
    # personal key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPurq4HYYHK0nxukQQAXm9mxlJ2/3plx79z0ckP3q/Q"

    # host ed25519 pubkey
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDohTbLr6SW9DDXekhHDrD+RoKf0u5hyYvuHu9Su+lF7 root@nixos"

    # dusty-cobweb pubkey
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgEflZNpuj93w/qqm/l9sNObr9q5PnYpm/ya+ME7vxq root@dusty-cobweb"
  ];
in
{
  "tailscale-authkey.age".publicKeys = keys;
}
