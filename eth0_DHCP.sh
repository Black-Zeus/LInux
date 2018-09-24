#!/bin/bash

clear

echo "Configuracion DHCP interfaz eth0"
# Configuracion por DHCP
ifconfig eth0 down  # tear eth0 down/drop its current DHCP settings
ifconfig eth0 up    # bring it back up
dhclient eth0       # poll for new and complete DHCP settings which include th$

echo
ifconfig eth0
