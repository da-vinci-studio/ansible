docker run --rm -it -v ${pwd}/ansible:/ansible/playbooks -v  ~/.ssh:/root/ssh bkosciow/ansible install $1 $2