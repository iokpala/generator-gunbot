#!/bin/bash
NAME="gunbot-$1"
INSTALL="https://github.com/redindian/generator-gunbot/raw/master/install.sh"
# create docker with name
docker run --name $NAME -d ubuntu tail -f /dev/null
# default exec command
EXEC="docker exec $NAME bash -c "
# update, upgrade and install
$EXEC 'apt-get update && apt-get -y upgrade'
$EXEC 'apt-get -y install curl unzip vim'
# run installer
$EXEC 'curl -qsL '"$INSTALL"' | bash'
# open command line
docker exec -it $NAME /bin/bash
