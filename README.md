# kalinkina_infra
kalinkina Infra repository

#Homework #2
##Add Pull Request Template

``` 
mkdir .github
cd .github
wget http://bit.ly/otus-pr-template -O PULL_REQUEST_TEMPLATE.md
git add PULL_REQUEST_TEMPLATE.md
git commit -m 'Add PR template'
git push --set-upstream origin play-travis 
```

##Integration with travis CI
1) Add .travis.yml file
```
dist: trusty
sudo: required
language: bash
before_install:
- curl https://raw.githubusercontent.com/express42/otus-homeworks/2019-05/run.sh |
bash
```
2) Add Slack integration. Add apps -> Travis CI (View) -> Settings. Add configuration.

3) Encrypted token:

```
  - install ruby and rubygems
  - gem install travis
  - travis login --com
  - travis encrypt "devops-team-otus:<ваш_токен>#<имя_вашего_канала>" \
--add notifications.slack.rooms --com
```

4) Test integration

```
mkdir play-travis
wget https://raw.githubusercontent.com/express42/otus-snippets/master/hw-04/test.py
git commit -am "Commit"
```

#Homework #3

1) Connect with someinternalhost through bastion
```
ssh -J bastion_ip someinternalhost_ip
```

2) Connect with someinternalhost through bastion via hostname 
  - add in .ssh/config

```
Host bastion
Hostname <external_ip>

Host someinternalhost
Hostname <internal_ip>
``
  - ``` ssh -J bastion someinternalhost ```

3) Install pritunl
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

#Homework #4
```
testapp_IP = 35.221.228.74
testapp_port = 9292
```
## Create gcloud instance with startup-script

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
##Create firewall rule through consol
```
gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --target-tags=puma-server
```

#Homework #5

##Create image through Packer
 - install packer
 - install ADC(Application Default Credentials)
```
 gcloud auth application-default login
```
 - create template ubuntu16.json
 - check errors ``` packer validate ./ubuntu16.json ```
 - packer build ubuntu16.json

##Template User Variables
1-3) packer build -var 'machine_type=f1-micro' -var-file=variables.json.example ubuntu16.json
4) Backed image in immutable.json
5) create-redditvm.sh create instance founded on reddit-full image_family
