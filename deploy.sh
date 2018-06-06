#!/bin/sh

mkdir -p ~/.ssh
cp ~/ssh/* ~/.ssh
chmod 0600 ~/.ssh/id_rsa

cd /ansible/playbooks
echo starting $1_deploy.yml
ansible-playbook -i inventories/$1_deploy $1_deploy.yml 
