#!/bin/bash

echo Actualizando Sistema

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get full-upgrade -y

echo Limpiando

apt-get auto-remove
apt-get auto-clean
apt-get clean

sync
