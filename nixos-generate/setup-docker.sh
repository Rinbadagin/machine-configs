IMG=$(nixos-generate -c configuration.nix -f docker)
TAG=desk-friend-docker
echo "Image: $IMG - $TAG"
docker import $IMG $TAG
docker run --privileged $TAG /init
docker exec -it $TAG /run/current-system/sw/bin/bash
