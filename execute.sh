#!/bin/sh
sleep 1
echo "creating dir"
mkdir -p ~/.ssh
sleep 1
echo "copy"
cp ~/ssh/* ~/.ssh
chmod 0600 ~/.ssh/*

if [[ "$1" == "install" ]] ; then
	echo "INSTALL"
	echo inventories/$2 $3_install.yml
	ansible-playbook -vvvv -i inventories/$2 $3_install.yml
else	
	cd /ansible/playbooks
	echo starting $1_deploy.yml
	if [ ! -f inventories/$1 ]; then
	    ansible-playbook -i inventories/$1_deploy $1_deploy.yml
	else
	    ansible-playbook -i inventories/$1 $1_deploy.yml
	fi
fi	
