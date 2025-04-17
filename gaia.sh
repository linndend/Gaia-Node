#!/bin/bash

clear

center_text() {
  local text="$1"
  local width=$(tput cols)
  local padding=$(( (width - ${#text}) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

line=$(printf '=%.0s' $(seq 1 $(tput cols)))

echo "$line"
center_text "SETUP GAIA NODE"
echo "$line"

echo "1. Gaia with GPU"
echo "2. Gaia with CPU only"
read -p "Choose opsi (1 or 2): " choose

if [ "$choose" == "1" ]; then

echo "Installing..."

center_text() {
  local text="$1"
  local width=$(tput cols)
  local padding=$(( (width - ${#text}) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

line=$(printf '=%.0s' $(seq 1 $(tput cols)))

echo "$line"
center_text "INSTALL DEPENDENCIES AND ENV Using GPU"
echo "$line"

echo "🚀 Updating and remove cuda nvidia libcuda..."
apt remove --purge '^cuda.*' '^nvidia.*' '^libcuda.*' -y
sleep 5
apt autoremove
apt clean
apt update; apt upgrade -y
sleep 5

echo "🚀Install deb..."
wget http://ftp.debian.org/debian/pool/main/n/ncurses/libtinfo5_6.1+20181013-2+deb10u2_amd64.deb
sleep 5
dpkg -i libtinfo5_6.1+20181013-2+deb10u2_amd64.deb
apt -f install
sleep 10

echo " Install cuda curl lsof..."
apt install -y nvidia-cuda-toolkit software-properties-common curl lsof git
sleep 5
wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
sleep 5
sh cuda_12.2.2_535.104.05_linux.run --silent --override --toolkit --samples --toolkitpath=/usr/local/cuda-12 --samplespath=/usr/local/cuda --no-opengl-libs
echo 'export PATH=/usr/local/cuda-12/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
ln -sfn /usr/local/cuda-12 /usr/local/cuda

echo "🚀Setup Gaianet dependencies..."
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --ggmlcuda 12
source ~/.bashrc
sleep 5

echo " Setting config Gaia..."
sleep 3
echo " Im using qwen2-0.5b..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

echo " Starting Gaianet Node..."
gaianet start
sleep 5

echo " Check your node id and user..."
gaianet info

echo "✅ Setup complete!"

elif [ "$choose" == "2" ]; then

center_text() {
  local text="$1"
  local width=$(tput cols)
  local padding=$(( (width - ${#text}) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

line=$(printf '=%.0s' $(seq 1 $(tput cols)))

echo "$line"
center_text "INSTALL DEPENDENCIES GAIANET with CPU only"
echo "$line"

curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
source ~/.bashrc
sleep 5

echo " Setting config Gaia..."
sleep 3
echo " Im using qwen2-0.5b..."
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

echo " Starting Gaianet Node..."
gaianet start
sleep 5

echo " Check your node id and user..."
gaianet info

echo "✅ Setup complete!"

else
    echo "❌ Pilihan tidak valid. Silakan jalankan ulang script."
    exit 1
fi
