#!/usr/bin/env bash

# Upgrade pip
/Library/Developer/CommandLineTools/usr/bin/python3 -m pip install --upgrade pip
python3 -m pip install pyright virtualenv yapf flake8
npm install -g typescript typescript-language-server eslint prettier
