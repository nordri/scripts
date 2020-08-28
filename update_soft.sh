#!/usr/bin/env bash
set -e

# This script will update some packages which are not part of
# a package manager to the latest version.

# Fede Diaz (nordri@gmail.com) June 2020

# Changelog
#
# 06/26/2020 First version

[[ "$DEBUG" == "true" ]] && set -x

TMP_DIR=$(mktemp -d)

# Vscodium
DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/VSCodium/vscodium/releases/latest" | jq -r '.assets[] | select(.content_type | contains("application/x-debian-package")) | select(.name | contains("amd64")) | .browser_download_url')
curl -L ${DOWNLOAD_URL} --output $TMP_DIR/vscodium.deb
sudo dpkg -i ${TMP_DIR}/vscodium.deb

# Terraform
DOWNLOAD_URL=$(curl --silent -L https://www.terraform.io/downloads.html | grep linux_amd64.zip | sed 's:<a href="\(.*\)">.*</a>:\1:' | sed 's:<li>\(.*\).*</li>:\1:' | sed -e 's/^[ \t]*//')
curl -L ${DOWNLOAD_URL} --output $TMP_DIR/terraform.zip
pushd $TMP_DIR
unzip $TMP_DIR/terraform.zip
sudo mv terraform /usr/local/bin/terraform
popd

# Vagrant
LATEST_VERSION=$(curl --silent https://www.vagrantup.com/ | grep -oh "Download [0-9]\+.[0-9]\+.[0-9]\+" | cut -d" " -f2)
curl --silent -L https://releases.hashicorp.com/vagrant/${LATEST_VERSION}/vagrant_${LATEST_VERSION}_linux_amd64.zip --output $TMP_DIR/vagrant.zip
pushd $TMP_DIR
unzip $TMP_DIR/vagrant.zip
sudo mv vagrant /usr/local/bin/vagrant
popd

# Minikube
pushd $TMP_DIR
curl -L --output minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube \
  && sudo mv minikube /usr/bin/minikube
