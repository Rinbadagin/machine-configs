#!/run/current-system/sw/bin/env zsh
set -e
{
    nix flake check
    ./update.sh dusty-cobweb
    ./update.sh desk-friend
    # achilles has the repo locally - build it there instead
    ssh root@achilles "tmux new-session -d -s rb_sess 'rebuild'"
    rebuild
    
} | tee logs/$(date).txt