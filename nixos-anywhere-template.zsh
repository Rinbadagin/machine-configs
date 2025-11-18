#!/run/current-system/sw/bin/env zsh

if [ -z "$1" ]; then
  echo "flake?"
  flake=$(read -e)
else
  flake=$1
fi

if [ -z "$2" ]; then
  echo "user@host?"
  host=$(read -e)
else
  host=$2
fi

if read -q "choice? add hardware option"; then
  hw="--generate-hardware-config nixos-generate-config ./hardware-configuration.nix"
else
  hw=""
fi
echo

echo "nix run github:nix-community/nixos-anywhere -- --flake '.#${flake}' --target-host ${host} ${hw}"
