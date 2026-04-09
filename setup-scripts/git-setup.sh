#!/bin/bash

SSH_KEY_DIR="$HOME/.ssh/github"
SSH_KEY_TEST="$PWD/test"

mkdir -p "$SSH_KEY_DIR"

read -p "Email for git: " email

if [[ $email == "" || $email == " " ]]; then
	echo "No email"

elif [[ $email != $"" ]]; then
	ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY_DIR/git-key"
	echo "Copy value & create git ssh KEY: "
	cat $SSH_KEY_DIR/git-key.pub
	read -p "[!] Continue? [y/n]: " action

	if [[ $action == "y" || $action == "Y" ]]; then
		eval "$(ssh-agent -s)"
		ssh-add $SSH_KEY_DIR/git-key
		ssh -T git@github.com
	fi

fi
