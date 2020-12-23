#!/bin/sh
sleep 1
echo "creating dir"
mkdir -p ~/.ssh
sleep 1
echo "copy"
cp ~/ssh/* ~/.ssh
chmod 0600 ~/.ssh/*

EXTRA=''
DEBUG=''
HAS_EXTRA=0

for var in "$@"
do
    if [ "$var" = "--debug" ]; then
        DEBUG="-vvv"
    fi
    if [ "$var" = "--extra-vars" ]; then
        HAS_EXTRA=1
    elif [ -n "$HAS_EXTRA" ]; then
        EXTRA="${EXTRA} ${var}"
    fi
done

if [[ "$1" == "install" ]] ; then
	echo "Executing INSTALL"
	echo $DEBUG -i inventories/$2 $3_install.yml
	ansible-playbook $DEBUG -i inventories/$2 $3_install.yml
elif [[ "$1" == "manage" ]] ; then
	echo "Executing MANAGE"
	echo $DEBUG -i inventories/$2 $3_manage.yml --extra-vars "${EXTRA}"
	ansible-playbook $DEBUG -i inventories/$2 $3_manage.yml --extra-vars "${EXTRA}"
elif [[ "$1" == "run" ]]; then	
	echo "Executing RUN $3 on $2"
	ansible-playbook $DEBUG -i inventories/$2 $3.yml $4
else	
  echo "Executing DEPLOY"
	cd /ansible/playbooks
	if [ ! -f inventories/$1 ]; then
	    echo  $DEBUG -i inventories/$1_deploy $1_deploy.yml $2
	    ansible-playbook $DEBUG -i inventories/$1_deploy $1_deploy.yml $2
	else
	    echo $DEBUG -i inventories/$1 $1_deploy.yml $2
	    ansible-playbook $DEBUG -i inventories/$1 $1_deploy.yml $2
	fi
fi	
