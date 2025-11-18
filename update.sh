#!/run/current-system/sw/bin/env zsh
set -e


if [ -z "$1" ]; then
  echo "Flake?"
  flake=$(read -e)
else
  flake=$1
fi

if [ -z "$2" ]; then
  echo "User@host?"
  host=$(read -e)
else
  host=$2
fi

echo "Commit message?"
commit_msg=$(read -e)
nix flake lock
git add .
if ! [ -z "${commit_msg}" ]; then
  git commit -m "${commit_msg}"
fi

echo "nixos-rebuild switch --flake '.#${flake}' --target-host '${host}'"
nixos-rebuild switch --flake ".#${flake}" --target-host "${host}"

if [ $? -eq 0 ]; then
  if [ -z "${commit_msg}" ]; then
    echo "Success. No commit message, leaving as is"
  else
    echo "Pushing (latest: ${commit_msg})"
    git push
  fi
else
  if [ -z "${commit_msg}" ]; then
    echo "Failure. No commit message, leaving as is"
  else
    echo "Resetting softly. Commit: ${commit_msg}"
    git reset --soft HEAD~1
  fi
fi

