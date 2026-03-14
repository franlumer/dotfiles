#!/bin/bash

dependencies=(zsh git eza curl ca-certificates fonts-powerline)

for i in "${dependencies[@]}"
do
    if which "$i" &>/dev/null; then
        echo "$i intstalado"
    else
        echo "$i no instalado"
    fi
done 

