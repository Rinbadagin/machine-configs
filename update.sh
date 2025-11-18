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
git commit -m "${commit_msg}"
nixos-rebuild switch --flake ".#${flake}" --target-host "${host}"

if [ $? -eq 0 ]; then
  echo "Success. Pushing (latest: ${commit_msg})"
  git push
else
  echo "Failure. Resetting softly. Commit: ${commit_msg}"
  git reset --soft HEAD~1
fi

