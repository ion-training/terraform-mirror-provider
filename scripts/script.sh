echo ${HOSTNAME}

# install terraform
export TFVER=1.1.4

which terraform &>/dev/null || {

    # deps to download TF
    which curl unzip git tree &>/dev/null || {
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get install -y curl unzip git tree
    }

    pushd /usr/local/bin
    curl -fsSL https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip -o terraform_${TFVER}_linux_amd64.zip
    unzip terraform_${TFVER}_linux_amd64.zip
    rm terraform_${TFVER}_linux_amd64.zip
    popd
}

# create directory for terraform projects
mkdir /vagrant/terraform-proj
