#!/bin/bash
##########################################################################################
## Author: Black-Zeus                                                                  ###
## Created: 2018-09-26                                                                 ###
## Description: El presente Script, esta enfocado en la preparacion de un servidor     ###
##                 Web, para esto carga los siguietnes Servicios                       ###
##                  * Update Centos                                                    ###
##                  * Apache                                                           ###
##                  * MySql / MariaDB                                                  ###
##                  * Php                                                              ###
##                  * Acceso SSH / SFTP                                                ###
##                  * Servicio FTP                                                     ###
##########################################################################################
##########################################################################################
### Boque de Presentacion                                                              ###
##########################################################################################
fn_banner() {
    if hash figlet 2>/dev/null; then
        figlet Black-Zeus
    else
        if fn_checkroot_Bool; then
          yum install figlet  2>&1 >> /dev/null;
          figlet Black-Zeus
        else
          echo "-------------------";
          echo "--  Black - Zeus  --";
          echo "-------------------";
        fi
    fi

    ### Datos del Banner ##
    echo "-------------------------------------------------";
    echo "-- Script de Preparacion LAMP Centos v0.1 Beta --";
    echo "-------------------------------------------------";
    echo "";
}

fn_OpcionesMenu(){
  echo "";
  echo "-- Seleccione una de las siguientes opciones";
  echo "-> 1.- Informacion del sistema";
  echo "-> 2.- Instalar LAMP Automatizado'";
  echo "-> 3.- Instalar LAMP Manual";
  echo "-> 4.- Instalar Programas Imprescindibles (Automatizado)";
  echo "-> 0.- Cerrar";
  echo "";
}

fn_checkroot_Bool(){
  if ! [ $(id -u) = 0 ]; then
    return 1;
  else
    return 0;
  fi
}

fn_SalirBash(){
  clear
  fn_banner;

  echo "";
  echo "Gracias por Emplear este Script";
  fn_PleaseWait;
  reset
}

fn_PleaseWait(){
  echo "";
  read -p "<<-- Presione la tecla [ENTER] para Continuar -->>";
}

##########################################################################################
### Bloque Seccion: Informacion del sistema                                            ###
##########################################################################################
fn_checkroot(){
  if ! fn_checkroot_Bool; then
    echo "$USER no es usuario ROOT"
  else
    echo "$USER es usuario ROOT"
  fi
}

fn_HoraSystem() {
    if hash gdate 2>/dev/null; then
        gdate "$@"
    else
        date "$@"
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

  ### Datos de Usuario COnectado ##
  echo "-------------------------------------";
  echo "-- UpTime           ";
  echo "-------------------------------------";
  echo "-- Hora Encendido: $(uptime -s) ||  Horas Encendido: $(uptime -p)";
  echo "";

  ### Datos de HardWare ##
  echo "-------------------------------------";
  echo "-- Memoria                 ";
  echo "-------------------------------------";
  free -ht

  echo "";
  echo "-------------------------------------";
  echo "-- Disco Duro                 ";
  echo "-------------------------------------";
  df -h /
  echo "";
}
##########################################################################################
### Bloque Seccion: Instalar Programas Imprescindibles                                 ###
##########################################################################################
fn_OPcionErronea(){
  echo "";
  echo "<<-- La Opcion ingresada no es Valida -->>";
}

##########################################################################################
### Bloque Seccion: Bucle a cargo de mostrar el Menu                                   ###
##########################################################################################
display_main_menu() {

    while true; do
      clear
      fn_banner;
      fn_OpcionesMenu;

      read -p "Ingrese opcion: " OpcSeleccion;

      case $OpcSeleccion in
        1 ) reset; fn_InfoSession; fn_PleaseWait;;
        2 ) reset; fn_UtimosAccesos; fn_PleaseWait;;
        3 ) reset; fn_UpdateSystem; fn_PleaseWait;;
        4 ) reset; fn_InstallSistem; fn_PleaseWait;;
        0 ) fn_SalirBash; exit;;
        * ) echo fn_OPcionErronea; fn_PleaseWait;;
      esac
    done
}

##########################################################################################
### Bloque Seccion: Llamada al Menu                                                    ###
##########################################################################################
reset
display_main_menu;
