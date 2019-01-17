Ansible in container for install and deploy tasks

windows:

    deploy.ps1 dev|stage|prod|..
    install.ps1 inventory playbook
    
	docker run --rm -it -v ${PWD}/ansible:/ansible/playbooks -v  ${env:USERPROFILE}/.ssh:/root/ssh bkosciow/ansible {dev|stage|prod}
	docker run --rm -it -v ${PWD}/ansible:/ansible/playbooks -v  ${env:USERPROFILE}/.ssh:/root/ssh bkosciow/ansible install {inventory} {playbook}

linux:

    deploy.sh dev|stage|prod|..
    install.sh inventory playbook
    
	docker run --rm -it -v ${pwd}/ansible:/ansible/playbooks -v  ~/.ssh:/root/ssh bkosciow/ansible {dev|stage|prod}
	docker run --rm -it -v ${pwd}/ansible:/ansible/playbooks -v  ~/.ssh:/root/ssh bkosciow/ansible install {inventory} {playbook}


Dir .ssh is not mapped directly to home because of windows permission problems. It is mapped in different folder and then copied with correct permissions
 