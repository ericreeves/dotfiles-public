#!/bin/bash

############################################################
# Install 1Password CLI in Ubuntu
############################################################
if [ -n "$(lsb_release -i | grep Ubuntu)" ]; then
    if [ ! -x /usr/local/bin/op ]; then
        echo "--- Installing 1password-cli in Ubuntu"           
        pushd /tmp >/dev/null
        wget -O op.zip https://cache.agilebits.com/dist/1P/op/pkg/v1.12.4/op_linux_amd64_v1.12.4.zip
        unzip op.zip && rm op.zip op.sig
        chmod +x op
        sudo mv op /usr/local/bin/
        popd
    fi
fi


############################################################
# Install 1Password CLI in Fedora
############################################################
if [ -n "$(lsb_release -i | grep Fedora)" ]; then
    echo "--- Installing 1password and 1password-cli in Fedora"           
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install 1password 1password-cli
fi


############################################################
# Setup 1Password CLI
############################################################
echo "--- Signing into 1Password (eric@alluvium.com)"
op signin my >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -n "1Password Secret Key: "
  read -r OP_SECRET_KEY
  op signin my eric@alluvium.com $OP_SECRET_KEY
  if [ $? -ne 0 ]; then
	echo "--- 1Password Signin FAILED"
	exit 1
  fi
fi


############################################################
# Authenticate 1Password Session
############################################################
eval $(op signin my)


############################################################
# Add cd15-master
############################################################

if [ -n "$(chezmoi data | jq -r .usage | grep work)" ]; then
    echo "--- Configuring AWS Account: cd15-master"
    # Retrieve Credentials from 1Password
    AL_ID=$(op get item --fields 'Username' "AWS cd15-master IAM eric")
    AL_KEY=$(op get item --fields 'Password' "AWS cd15-master IAM eric")

    # Store Credentials in File Temporarily
    cat >~/.aws/credentials.alertlogic.env <<EOF
export AWS_ACCESS_KEY_ID=$AL_ID
export AWS_SECRET_ACCESS_KEY=$AL_KEY
EOF

    # Add to aws-vault
    source ~/.aws/credentials.alertlogic.env
    aws-vault add --env cd15-master

    # Remove Temporary Credentials File
    rm ~/.aws/credentials.alertlogic.env
fi


############################################################
# Add litex
############################################################


echo "--- Configuring AWS Account: litex"
# Retrieve Credentials from 1Password
MY_ID=$(op get item --fields 'Username' "AWS - Keys - litex IAM User")
MY_KEY=$(op get item --fields 'Password' "AWS - Keys - litex IAM User")

# Store Credentials in File Temporarily
cat >~/.aws/credentials.litex.env <<EOF
export AWS_ACCESS_KEY_ID=$MY_ID
export AWS_SECRET_ACCESS_KEY=$MY_KEY
EOF

# Add to aws-vault
source ~/.aws/credentials.litex.env
aws-vault add --env litex

# Remove Temporary Credentials File
rm ~/.aws/credentials.litex.env

