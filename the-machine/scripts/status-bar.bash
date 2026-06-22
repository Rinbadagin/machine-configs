#!/run/current-system/sw/bin/env bash
bat=$(sudo tlp-stat -b | grep "Charge" | sed -rn "s/.*([0-9\.]{4}).*/\1/p")
state=$(sudo tlp-stat -b | grep "/status" | sed -re "s/.*\s+([a-zA-Z]+)/\1/")
echo $bat% $state $(date +'%Y-%m-%d %X')
