# kalinkina_infra
kalinkina Infra repository

Add Pull Request Template

``` 
mkdir .github
cd .github
wget http://bit.ly/otus-pr-template -O PULL_REQUEST_TEMPLATE.md
git add PULL_REQUEST_TEMPLATE.md
git commit -m 'Add PR template'
git push --set-upstream origin play-travis 
```

Integration with travis CI
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
