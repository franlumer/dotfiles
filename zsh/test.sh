#!/bin/bash

SSH_KEY_DIR="~/.ssh/id_ed25519_git"
SSH_KEY_TEST="$PWD/test"

read -p "Email for git: " email

if [[ $email == "" ]]; then
	echo "No email"

elif [[ $email != "" ]]; then
	ssh-keygen -t ed25519 -C "$email" -f $SSH_HEY_TEST
	cat id_test
	echo "Copy value & create git ssh KEY"
	read -p "Continue? [y/n]" action

	if [[ $action == "y" || $action == "Y" ]]; then
		eval "$(ssh-agent -s)"
		ssh-add $SSH_HEY_TEST
		ssh -T git@github.com
	fi


fi
