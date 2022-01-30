# terraform-mirror-provider
download a provider from a private repository (explicit configuration installation)

# How to use this repo
Clone and cd into repo
```
git clone https://github.com/ion-training/terraform-mirror-provider.git
```
```
cd terraform-mirror-provider
```

Vagrant up and SSH
```
vagrant up
```
```
vagrant ssh
```

# CLI setup for an explicit repository (local disk)
```
touch ~/.terraformrc
```
```
cat <<HEREDOC > ~/.terraformrc
provider_installation {
  filesystem_mirror {
    path    = "/vagrant/terraform-proj/local_providers/"
    include = ["registry.terraform.io/hashicorp/aws"]
  }

  direct {
    exclude = ["registry.terraform.io/hashicorp/aws"]
  }
}
HEREDOC
```

Create a directory where local_providers will be placed
```
mkdir -p /vagrant/terraform-proj/local_providers/
```
Directory structure should look like (check `Packet layout` at this [link](https://www.terraform.io/cli/config/config-file#provider-installation))
- `HOSTNAME/NAMESPACE/TYPE/terraform-provider-TYPE_VERSION_TARGET.zip`

Within the local_providers create directory structure to place the binary
```
mkdir -p /vagrant/terraform-proj/local_providers/registry\.terraform\.io/hashicorp/aws
```

Using a subshell cd into the aws directory (`HOSTNAME/NAMESPACE/TYPE/`),\
and download the aws provider from releases.hashicorp.com
```
( cd /vagrant/terraform-proj/local_providers/registry\.terraform\.io/hashicorp/aws && \
curl --remote-name https://releases.hashicorp.com/terraform-provider-aws/3.74.0/terraform-provider-aws_3.74.0_linux_amd64.zip )
```

Create main.tf file and use the aws provider,\
keeping in mind that `~/.terraformrc` will take care of the redirection to local disk.

```
touch main.tf
```
```
cat <<HEREDOC > main.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}
HEREDOC
```
In above main.tf the kubernetes provider was also used to demonstrate\
that aws provider will fetched from local disk while kubernetes provider via internet.

Terraform init
```
terraform init
```

# Destroy the lab
Exist out of the vagrant box and destroy the vm
```
vagrant destroy -f
```
```
rm -rf terraform-proj
```


# Sample output
```
vagrant@vagrant:/vagrant/terraform-proj$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/kubernetes versions matching "2.7.1"...
- Finding hashicorp/aws versions matching "3.74.0"...
- Installing hashicorp/kubernetes v2.7.1...
- Installed hashicorp/kubernetes v2.7.1 (signed by HashiCorp)    <<< -- downloaded from registry, thus authenticated
- Installing hashicorp/aws v3.74.0...
- Installed hashicorp/aws v3.74.0 (unauthenticated)              <<< -- downloaded locally and seen as unauthenticated

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
vagrant@vagrant:/vagrant/terraform-proj$
```

Directory structure
```
vagrant@vagrant:/vagrant/terraform-proj$ tree -a
.
├── local_providers
│   └── registry.terraform.io
│       └── hashicorp
│           └── aws
│               └── terraform-provider-aws_3.74.0_linux_amd64.zip   <<<-- this is unzipped and copied in .terraform
├── main.tf
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           └── hashicorp
│               ├── aws
│               │   └── 3.74.0
│               │       └── linux_amd64
│               │           └── terraform-provider-aws_v3.74.0_x5    <<<-- extracted and copied here from local_providers dir
│               └── kubernetes
│                   └── 2.7.1
│                       └── linux_amd64
│                           └── terraform-provider-kubernetes_v2.7.1_x5  <<<-- copied from via internet
└── .terraform.lock.hcl

14 directories, 5 files
vagrant@vagrant:/vagrant/terraform-proj$ 
```
