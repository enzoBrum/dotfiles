#!/bin/bash

set -e

curdir=$(pwd)
mkdir build

mkdir build/zellij
cd build/zellij 
URL=$(curl  https://github.com/zellij-org/zellij/releases/latest/ -sL -w %{url_effective} -o /dev/null | xargs | sed 's/tag/download/')
wget $URL/zellij-x86_64-unknown-linux-musl.tar.gz -O zellij.tar.gz
tar xvf zellij.tar.gz 
mv zellij $HOME/.local/bin/zellij

cd ..
mkdir chezmoi

cd chezmoi

git clone https://github.com/twpayne/chezmoi.git
cd chezmoi

wget https://github.com/twpayne/chezmoi/releases/download/$(git ls-remote --tags --sort=-committerdate | grep -o "v.*" | head -n 1)/chezmoi_$(git ls-remote --tags --sort=-committerdate | grep -o "v.*" | head -n 1 | sed 's/v//' )_linux_amd64.tar.gz -O chezmoi.tar.gz

tar xvf chezmoi.tar.gz

cp chezmoi $HOME/.local/bin/chezmoi
cp completions/chezmoi.fish $HOME/.config/fish/completions/chezmoi.fish

cd ../..

mkdir eza

cd eza

git clone https://github.com/eza-community/eza.git
cd eza

version=$(git ls-remote --tags --sort=-committerdate | grep -Eo "v[0-9]+(\.[0-9]+)*" | head -n 1)
git checkout $version

wget https://github.com/eza-community/eza/releases/download/$version/eza_x86_64-unknown-linux-gnu.tar.gz -O eza.tar.gz

tar xvf eza.tar.gz
cp eza $HOME/.local/bin/eza

cp completions/fish/eza.fish $HOME/.config/fish/completions/eza.fish

cd $curdir
rm -rf build
