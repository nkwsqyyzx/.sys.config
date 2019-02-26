apt-get install -y vim
apt-get install -y git
apt-get install -y openjdk-8-jdk
apt-get install -y tmux
apt-get install -y openssh-server
apt-get install -y zsh
apt-get install -y curl
apt-get install -y python
apt-get install -y python-dev
apt-get install -y python3-dev
apt-get install -y python-tk


wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py

# python
pip install bs4 qrcode Image

# machine learning
pip install numpy matplotlib xgboost sklearn PyWavelets
