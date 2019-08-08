# kalinkina_infra
kalinkina Infra repository
***
## Homework № 1

#### Add Pull Request Template
```
mkdir .github
cd .github
wget http://bit.ly/otus-pr-template -O PULL_REQUEST_TEMPLATE.md
git add PULL_REQUEST_TEMPLATE.md
git commit -m 'Add PR template'
git push --set-upstream origin play-travis
```

#### Integration with travis CI
1. Add .travis.yml file
```
dist: trusty
sudo: required
language: bash
before_install:
- curl https://raw.githubusercontent.com/express42/otus-homeworks/2019-05/run.sh |
bash
```
2. Add Slack integration. Add apps -> Travis CI (View) -> Settings. Add configuration.
3. Encrypted token:
```
  - install ruby and rubygems
  - gem install travis
  - travis login --com
  - travis encrypt "devops-team-otus:<ваш_токен>#<имя_вашего_канала>" \
--add notifications.slack.rooms --com
```
4. Test integration
```
mkdir play-travis
wget https://raw.githubusercontent.com/express42/otus-snippets/master/hw-04/test.py
git commit -am "Commit"
```
***

## Homework №2

1. Connect with someinternalhost through bastion
`ssh -J bastion_ip someinternalhost_ip`
2. Connect with someinternalhost through bastion via hostname
  - add in .ssh/config
```
Host bastion
Hostname <external_ip>

Host someinternalhost
Hostname <internal_ip>
```
  - ``` ssh -J bastion someinternalhost ```

3. Install pritunl
  - script for installation
```
#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
```
  - configure pritunl through https://<ip_server>/setup
  https://docs.pritunl.com/docs/connecting
  - open port for pritunl
  - check connection using pritunl-client

Data for checking:
```
bastion_IP = 35.206.161.239
someinternalhost_IP = 10.128.0.3
```
***

## Homework №3
```
testapp_IP = 35.221.228.74
testapp_port = 9292
```
#### Create gcloud instance with startup-script

```
gcloud compute instances create test \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata-from-file startup-script=<location_of_script>/kalinkina_infra/startup.sh
```
#### Create firewall rule through consol
`
gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --target-tags=puma-server`
***

## Homework №4

#### Create image through Packer
 - install packer
 - install ADC(Application Default Credentials)
`gcloud auth application-default login`
 - create template ubuntu16.json
 - check errors 
` packer validate ./ubuntu16.json `
 - packer build ubuntu16.json

#### Template User Variables
1-3.  `packer build -var 'machine_type=f1-micro' -var-file=variables.json.example ubuntu16.json`
4. Backed image in immutable.json
5. create-redditvm.sh create instance founded on reddit-full image_family
***

## Homework #6
#### IaC with terraform
(using terraform 0.11.11)

>Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.
 - First create a Terraform config file named main.tf.
```
provider "google" {
  project = "{{YOUR GCP PROJECT}}"
  region  = "us-central1"
  zone    = "us-central1-c"
}
```
>Not all resources require a location. Some GCP resources are global and are automatically spread across all of GCP.
 - terraform init  (download the latest version of the provider and build the .terraform directory)
 - create VM instance with resource "google_compute_instance"
```
resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }
  # определение сетевого интерфейса
  network_interface {
  # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
}
```
 - terraform plan:
    * Verify the syntax of main.tfis correct
    * Ensure the credentials file exists (contents will not be verified until terraform apply)
    * Show a preview of what will be created
 - terraform apply

##### Data of our VM
 - terraform.tfstate (file)
 - terraform show (command)

#### Output Variables
 - define outputs in *.tf file
 - terraform refresh or terraform apply
 - terraform output for showing

#### Provisioners
>Provisioners are used to execute scripts on a local or remote machine as part of resource creation or destruction. Provisioners can be used to bootstrap a resource, cleanup before destroy, run configuration management, etc.
Provisioners are added directly to any resource.
 - add Provisioners to resource "google_compute_instance" "app"
```
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
```
 - add connection to provisioners
> Many provisioners require access to the remote resource. For example, a provisioner may need to use SSH or WinRM to connect to the resource.
Terraform uses a number of defaults when connecting to a resource, but these can be overridden using a connection block in either a resource or provisioner. Any connection information provided in a resource will apply to all the provisioners, but it can be scoped to a single provisioner as well.
```
connection {
  type        = "ssh"
  user        = "appuser"
  agent       = false
  private_key = "${file("~/.ssh/appuser")}"
}
```
>By default, provisioners run when the resource they are defined within is created. Creation-time provisioners are only run during creation, not during updating or any other lifecycle. They are meant as a means to perform bootstrapping of a system.
 so
 - terraform taint google_compute_instance.app
 - terraform apply

#### Input vars
 **1. Define variables in variables.tf**
 ```
variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
```
  **2. Using variables in configuration**
      "${var.var_name}" in main.tf
 - assigning variables
     1. Command-line flags like `terraform apply  -var 'region=us-east-2'`
     2. From a file terraform.tfvars or *.auto.tfvars or use the -var-file flag directly to specify a file
```
project = "infra-179015"
public_key_path = "~/.ssh/appuser.pub"
disk_image = "reddit-base"
```
 - terraform plan
 - terraform apply

#### Tasks
 - terraform fmt like linter for terraform files
 - add new input Variables in terraform.tfvars.example

#####  Tasks with *
 1. If you want one ssh key you can use resourse google_compute_project_metadata_item
 example
 ```
 resource "google_compute_project_metadata_item" "default" {
  key = "my_metadata" #username
  value = "my_value" #location of key
}
```
 2. Add ssh key to project for multiple users
 ```
 resource "google_compute_project_metadata" "default" {
   metadata = {
     appuser  = "${file("~/.ssh/id_rsa_test.pub")}"
     appuser1 = "${file("~/.ssh/id_rsa_test.pub")}"
   }
 }
 ```

3. При запуске terraform apply ssh ключ, добавленный через веб-интерфейс, исчез
