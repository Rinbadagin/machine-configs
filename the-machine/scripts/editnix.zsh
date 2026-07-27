#!/run/current-system/sw/bin/env zsh

# this could do with some refactoring

set -e

if ! [[ -z $1 ]];
then
  if [[ $1 == "nocommit" ]];
  then
    # nocommit path goes here
    codium --wait ~/machine-configs
    sudo -- sh -c "nixos-rebuild switch"
    echo "Did the thing! have fun :3"
    exit 0
  elif [[ $1 == "justcommit" ]];
  then
    echo "Commit message?"
    msg=$(read -e)
    sudo -- sh -c "nixos-rebuild switch"
    (cd ~/machine-configs && git add . && git commit -m "$msg" && git push)
    echo "Commited $msg"
    exit 0
  else
    echo "optional nocommit flag, else fine"
    exit 1
  fi
fi

# regular path here
codium --wait ~/machine-configs
# sudo -- sh -c "vim /etc/nixos/"
echo "Commit message?"
msg=$(read -e)
sudo -- sh -c "nixos-rebuild switch"
(cd ~/machine-configs && git add . && git commit -m "$msg" && git push)
echo "Commited $msg"
