#!/bin/sh
sleep 1
echo "creating dir"
mkdir -p ~/.ssh
sleep 1
echo "copy"
cp ~/ssh/* ~/.ssh
chmod 0600 ~/.ssh/*
#echo $@

EXTRA=''
DEBUG=''
for var in "$@"
do
    if [[ "$var" == "--debug" ]]; then
        DEBUG="-vvv"
    fi
    if [[ "$var" == "--extra-vars" ]]; then
        EXTRA=" "
    elif [ ! -z "$EXTRA" ]; then
        EXTRA="${EXTRA} ${var}"
    fi
    echo "$var"
done

if [[ "$1" == "install" ]] ; then
	echo "INSTALL"
	echo inventories/$2 $3_install.yml
	ansible-playbook $DEBUG -i inventories/$2 $3_install.yml
elif [[ "$1" == "manage" ]] ; then
	echo "MANAGE"
	echo -v -i inventories/$2 $3_manage.yml --extra-vars "${EXTRA}"
	ansible-playbook $DEBUG -i inventories/$2 $3_manage.yml --extra-vars "${EXTRA}"
elif [[ "$1" == "run" ]]; then	
	echo "RUN $3 on $2"
	ansible-playbook $DEBUG -i inventories/$2 $3.yml $4
else	
	cd /ansible/playbooks
	echo starting $1_deploy.yml
	if [ ! -f inventories/$1 ]; then
	    ansible-playbook $DEBUG -i inventories/$1_deploy $1_deploy.yml $2
	else
	    ansible-playbook $DEBUG -i inventories/$1 $1_deploy.yml $2
	fi
fi	
