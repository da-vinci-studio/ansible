
win:

	docker run --rm -it -v ${PWD}/ansible:/ansible/playbooks -v  ${env:USERPROFILE}/.ssh:/root/ssh bkosciow/ansible dev|stage|prod

linux:

	docker run --rm -it -v ${pwd}/ansible:/ansible/playbooks -v  ~/.ssh:/root/ssh bkosciow/ansible dev|stage|prod
