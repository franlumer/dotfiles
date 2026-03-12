#!/bin/bash

dependencies=(zsh git eza curl ca-certificates fonts-powerline)

for i in "${dependencies[@]}"
do
    command -v "$i" &>/dev/null && echo "$i instalado" || echo "$i no instalado"
done


