#!/run/current-system/sw/bin/env zsh
set -e

echo "Commit message?"
commit_msg=$(read -e)
echo $commit_msg
nix flake lock
git add .
git commit -m "${commit_msg}"
nixos-rebuild switch --flake ".#deskFriend" --target-host "root@desk-friend-aertogig"

if [ $? -eq 0 ]; then
  echo "Success. Pushing (latest: $commit_msg )"
  git push
else
  echo "Failure. Resetting softly. Commit: $commit_msg"
  git reset --soft HEAD~1
fi

