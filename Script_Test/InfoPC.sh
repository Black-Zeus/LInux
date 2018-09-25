#!/bin/bash
#
clear
echo "
Selecciona una opción:
    1. Información del sistema
    2. Espacio libre y usado en disco
    3. Uso de disco por usuario en /home
    0. Salir
"
read -p "Introduce tu opción [0-3] > "

if [[ $REPLY =~ ^[0-3]$ ]]; then
    if [[ $REPLY == 0 ]]; then
        echo "Fin del script."
        exit
    fi
    if [[ $REPLY == 1 ]]; then
        echo "Hostname: $HOSTNAME"
        uptime
        exit
    fi
    if [[ $REPLY == 2 ]]; then
        df -h
        exit
    fi
    if [[ $REPLY == 3 ]]; then
        if [[ $(id -u) -eq 0 ]]; then
            echo "Uso de /home (All Users)"
            du -sh /home/*
        else
            echo "Uso de /home ($USER)"
            du -sh $HOME
        fi
        exit
    fi
else
    echo "Entrada incorrecta." >&2
    exit 1
fi
