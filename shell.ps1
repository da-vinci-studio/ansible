docker run --rm -it -v ${PWD}/ansible:/ansible/playbooks -v  ${env:USERPROFILE}/.ssh:/root/ssh --entrypoint "/bin/sh" bkosciow/ansible