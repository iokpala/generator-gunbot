#!/bin/bash

# Set variables
# -----------------------------------
URL="https://github.com/GuntharDeNiro/BTCT/releases/download/v3.3.5/Gunbot_v3.3.5_allOs.zip"
IFS='/' read -r -a array <<< $URL

VERSION="${array[-2]}"
FILENAME="${array[-1]}"
FILEBASE="${FILENAME%.*}"

GUNBOT_GITHUB_FOLDER_NAME="$VERSION"
GUNBOT_GITHUB_FILE_NAME="$FILEBASE"


# Set functions
# -----------------------------------
logMessage () {
  echo " $1"
  echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}


echo ""
echo " ============================================================"
echo "                    GUNBOT $GUNBOT_GITHUB_FOLDER_NAME SETUP started"
echo ""
echo "                This will take a few seconds"
echo ""
echo " ============================================================"
echo ""

logMessage "(1/7) Update the base system"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apt -qq update > /dev/null 2>&1
apt -y -qq upgrade > /dev/null 2>&1


logMessage "(2/7) Install tools"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
apt -y -qq install curl unzip vim wget > /dev/null 2>&1


logMessage "(3/7) Install nodejs 7.x"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
curl -qsL https://deb.nodesource.com/setup_7.x | bash - > /dev/null 2>&1
apt -y -qq install nodejs > /dev/null 2>&1


logMessage "(4/7) Install gunbot tools"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
npm install -g pm2 yo generator-gunbot gunbot-monitor > /dev/null 2>&1


logMessage "(5/7) Install GUNBOT"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wget -q $URL -P /opt/
unzip -o -qq /opt/$FILENAME -d /opt/

# creates a symbolic link to the gunbot folder
rm /opt/gunbot > /dev/null 2>&1
ln -s /opt/$GUNBOT_GITHUB_FILE_NAME /opt/gunbot

# Install patches
#wget -q https://github.com/GuntharDeNiro/BTCT/releases/download/Patch2019/Patch_Fixes_2019_all_CPU.zip -P /opt/
#unzip -o -qq /opt/Patch_Fixes_2019_all_CPU.zip -d /opt/gunbot

# Cleanup
rm /opt/$FILENAME
#rm /opt/Patch_Fixes_2019_all_CPU.zip

# Set rights
chmod +x /opt/gunbot/gunthy-*
# Move original config files
mkdir /opt/gunbot/originalConfigFiles -p
mv /opt/gunbot/ALLPAIRS-params.js /opt/gunbot/originalConfigFiles/ALLPAIRS-params.js > /dev/null 2>&1
mv /opt/gunbot/*-config.js /opt/gunbot/originalConfigFiles/*-config.js > /dev/null 2>&1


logMessage "(6/7) Add GUNBOT aliases"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "" >> ~/.bashrc
echo "# GUNBOT ALIASES" >> ~/.bashrc
echo "alias gcd='cd /opt/gunbot'" >> ~/.bashrc
echo "alias ginit='gcd && yo gunbot init'" >> ~/.bashrc
echo "alias gadd='gcd && yo gunbot add'" >> ~/.bashrc
echo "alias gl='pm2 l'" >> ~/.bashrc
echo "alias glog='pm2 logs'" >> ~/.bashrc
echo "alias gstart='pm2 start'" >> ~/.bashrc
echo "alias gstop='pm2 stop'" >> ~/.bashrc
echo "alias gsys='vmstat -s -S M | grep \"free memory\" && cat /proc/loadavg'" >> ~/.bashrc


logMessage "(7/7) Init generator"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create folder for yeoman.
chmod g+rwx /root
chmod g+rwx /opt/gunbot

# Yeoman write rights.
mkdir /root/.config/configstore -p
cat > /root/.config/configstore/insight-yo.json << EOM
{
        "clientId": 1337,
        "optOut": true
}
EOM
chmod g+rwx /root/.config
chmod g+rwx /root/.config/configstore
chmod g+rw /root/.config/configstore/*

# pm2 write rights.
mkdir /root/.pm2 -p
echo "1337" > /root/.pm2/touch
chmod g+rwx /root/.pm2
chmod g+rw /root/.pm2/*

# overwrite files
APP=/usr/lib/node_modules/generator-gunbot/generators/app/
wget -q https://raw.githubusercontent.com/redindian/generator-gunbot/master/generators/app/index.js -P $APP
wget -q https://raw.githubusercontent.com/redindian/generator-gunbot/master/generators/app/parameters.js -P $APP


echo ""
echo " ============================================================"
echo "                   GUNBOT SETUP complete!"
echo ""
echo "          Please run this command to init the GUNBOT:"
echo "                           ginit"
echo ""
echo " ============================================================"
echo ""
