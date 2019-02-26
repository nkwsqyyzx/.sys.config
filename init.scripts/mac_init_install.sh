/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

git -C "$(brew --repo homebrew/core)" fetch --unshallow

brew install tmux fzf autojump ipython python@2 wget cmake jq ag ack

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/nkwsqyyzx/.sys.config.git
echo "source ~/.sys.config/.bashrc" >> ~/.bashrc
echo "source ~/.sys.config/.zshrc" >> ~/.zshrc
(cd; ln -s ~/.sys.config/.tmux.conf)

git clone --recursive https://github.com/nkwsqyyzx/.vim.git
(cd; ln -s ~/.vim/.vimrc)
(cd ~/.vim/bundle/YouCompleteMe;./install.py)

brew cask install google-chrome android-studio pycharm-ce

brew cask install rowanj-gitx macvim spectacle

brew tap caskroom/fonts
brew cask install font-fira-code

brew cask install wechat java

cat <<EOF | sudo sh
wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py
# python
pip install bs4 qrcode Image
#
pip install numpy matplotlib xgboost sklearn PyWavelets

# python3
python3 /tmp/get-pip.py
pip3 install bs4 qrcode Image
pip3 install numpy matplotlib xgboost sklearn PyWavelets
pip3 install ipython
EOF
