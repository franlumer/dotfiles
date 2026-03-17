#!/bin/bash

if ! dpkg -l "$i" &>/dev/null; then
    echo "si"
fi