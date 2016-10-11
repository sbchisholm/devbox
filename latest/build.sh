#!/bin/bash

cp $HOME/.bashrc bashrc
docker build --tag=sbchisholm/devbox .
rm bashrc
