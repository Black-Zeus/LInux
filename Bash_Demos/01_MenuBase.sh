####################################################
# Author: Black-Zeus
# Created: 2018-09-25
# Description: Este Script genera un Menu base para la Aplicacion de diversas
#               funciones de mantenimiento y automatiazación
####################################################

#!/bin/bash

### Funciones y Procedimientos ####
fn_banner() {
    if hash figlet 2>/dev/null; then
        figlet Black-Zeus
    else
        echo "-------------------";
        echo "--  Back - Zeus  --"
        echo "-------------------";
    fi

    ### Datos del Banner ##
    echo "-------------------------------------";
    echo "-- Script de Automatizacion v0.1 Beta";
    echo "-------------------------------------";
    echo "";
}

fn_HoraSystem() {
    if hash gdate 2>/dev/null; then
        gdate "$@"
    else
        date "$@"
    fi
}

fn_checkroot(){
  if ! [ $(id -u) = 0 ]; then
    echo "$USER no es usuario ROOT"
  else
    echo "$USER es usuario ROOT"
  fi
}

fn_InfoSession(){
  clear
  ### Datos de La Version ##
  echo "-------------------------------------";
  echo "-- Informacion del sistema           ";
  echo "-------------------------------------";
  lsb_release -a
  echo "";

  ### Datos de Usuario COnectado ##
  echo "-------------------------------------";
  echo "-- Informacion del Usuario           ";
  echo "-------------------------------------";
  echo "-- Usuario Conectado: $(whoami)";
  echo "-- ROOT: $(fn_checkroot)";
  echo "-- Hora Sistema: $(fn_HoraSystem)";
  echo "-- HostName: $(hostname)";
  echo "-- IP's Local: $(hostname -I)";
  echo "-- IP's Publica: $(dig +short myip.opendns.com @resolver1.opendns.com)";
  echo "-------------------------------------"
  echo "";

  ### Datos Ultimos 5 Accesos
  echo "-------------------------------------";
  echo "-- Ultimos 5 Accesos           ";
  echo "-------------------------------------";
  last -5 -diwx vsoto
}

fn_OpcionesMenu(){
  echo ""
  echo "-- Script de automatiazación y Actualizacion";
  echo "";
  echo "-- Seleccione una de las siguientes opciones";
  echo "-> 1.- Informacion del sistema";
  echo "-> 2.- Instalacion de Progamas Impresindibles Automatizado";
  echo "-> 3.- Instalacion de Progamas Impresindibles Manual";
  echo "-> 4.- Instalacion LAMP Automatizado";
  echo "-> 0.- Cerrar";
  echo "";
}

fn_PleaseWait(){
  echo "";
  read -p "<<-- Presione la tecla [ENTER] para Continuar -->";
}

fn_SalirBash(){
  reset
  fn_banner;

  echo "";
  echo "Gracias por Emplear este Script";
  fn_PleaseWait;
}


########################################
### Bucle a cargo de mostrar el Menu ###
########################################
display_main_menu() {

    while true; do
      clear
      fn_banner;
      fn_OpcionesMenu;

      read -p "Ingrese opcion: " OpcSeleccion;

      case $OpcSeleccion in
        1 ) fn_InfoSession; fn_PleaseWait;;
        0 ) fn_SalirBash; exit;;
        * ) echo "Opcion No Valida."; fn_PleaseWait;;
      esac
    done
}

#######################
### Llamada al Menu ###
#######################
reset
display_main_menu;
