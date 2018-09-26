#!/bin/bash

####################################################
# Author: Black-Zeus
# Created: 2018-09-25
# Description: Este Script genera un Menu base para la Aplicacion de diversas
#               funciones de mantenimiento y automatiazación
####################################################

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

fn_checkroot_Bool(){
  if ! [ $(id -u) = 0 ]; then
    return 1;
  else
    return 0;
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

fn_UtimosAccesos(){
  clear

  ### Datos Ultimos 5 Accesos
  echo "-------------------------------------";
  echo "-- Ultimos 5 Accesos           ";
  echo "-------------------------------------";
  last -5 -diwx $USER

  ### Datos Ultimos 5 Accesos
  echo "-------------------------------------";
  echo "-- Ultimos 5 Reinicios                 ";
  echo "-------------------------------------";
  last reboot -F | head -5
}

fn_PleaseWait(){
  echo "";
  read -p "<<-- Presione la tecla [ENTER] para Continuar -->>";
}

fn_SalirBash(){
  clear
  fn_banner;

  echo "";
  echo "Gracias por Emplear este Script";
  fn_PleaseWait;
}

fn_UpdatePrivado(){
  echo "";
  echo "Actualizando Repositorios 'apt-get update'";
  echo "-> Update" >> $NombreLog 2>&1;
  apt-get update >> $NombreLog 2>&1;

  echo "";
  echo "Actualizando Sistema";
  echo "Actualizando Sistema" >> $NombreLog;

  echo "-> Upgrade";
  echo "-> Upgrade" >> 2>&1 >> $NombreLog;
  apt-get upgrade -y 2>&1 >> $NombreLog;

  echo "-> Instalando Dependencias Incumplidas";
  echo "-> Instalando Dependencias Incumplidas" >> $NombreLog;
  apt-get -f install -y 2>&1 >> $NombreLog;

  echo "-> Dist-Upgrade";
  echo "-> Dist-Upgrade" >> $NombreLog;
  apt-get dist-upgrade -y 2>&1 >> $NombreLog;

  echo "-> Full-Upgrade";
  echo "" >> $NombreLog;
  echo "-> Full-Upgrade" >> $NombreLog;
  apt-get full-upgrade -y 2>&1 >> $NombreLog;

  echo "";
  echo "Tareas de Mantenimiento";
  echo "-> Quitando paquetes no necesarios";

  echo "" >> $NombreLog;
  echo "Tareas de Mantenimiento" >> $NombreLog;
  echo "-> Quitando paquetes no necesarios" >> $NombreLog;
  apt-get auto-remove -y 2>&1 >> $NombreLog;

  echo "-> Quitando Temporales y Basuta";

  echo "" >> $NombreLog;
  echo "-> Quitando Temporales y Basuta" >> $NombreLog;
  apt-get auto-clean -y 2>&1 >> $NombreLog;
  apt-get clean -y 2>&1 >> $NombreLog;
  sync 2>&1 >> $NombreLog;
}

fn_UpdateSystem(){
  if fn_checkroot_Bool; then
  NombreLog="Log_Actualiza_"$(date +"%Y%m%d")."txt"
  rm -rf $NombreLog 2>&1;

  echo "-------------------------------------";
  echo "-- Proceso de Actualizacion de sistema";
  echo "-------------------------------------";

  fn_UpdatePrivado;

  echo "";
  echo "< Proceso de Actualizacion Terminado >";
  else
    echo "Debe ser usuario ROOT para ejecutar este Procedimiento"
  fi
}

fn_InstallSistem(){
  if fn_checkroot_Bool; then
  NombreLog="Log_Install_"$(date +"%Y%m%d")."txt";
  rm -rf $NombreLog 2>&1;

  echo "------------------------------------------------------";
  echo "-- Proceso de Instalacion de Programas Imprescindibles";
  echo "------------------------------------------------------";
  echo "";
  echo "-> Codecs";
  echo "-> Codecs" >> $NombreLog 2>&1;
  apt-get install ubuntu-restricted-extras >> $NombreLog 2>&1;

  echo "-> Compresores";
  echo "-> Compresores" >> 2>&1 >> $NombreLog;
  apt-get install -y unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip 2>&1 >> $NombreLog;

  echo "-> VLC";
  echo "-> VLC" >> 2>&1 >> $NombreLog;
  apt-get install -y vlc 2>&1 >> $NombreLog;

  echo "-> Java";
  echo "-> Java" >> 2>&1 >> $NombreLog;
  apt-get purge -y openjdk* 2>&1 >> $NombreLog;
  add-apt-repository -y ppa:webupd8team/java 2>&1 >> $NombreLog;
  apt-get update 2>&1 >> $NombreLog;
  apt-get install -y oracle-java8-set-default openjdk-8-jre 2>&1 >> $NombreLog;

  echo "-> Gdebi";
  echo "-> Gdebi" >> 2>&1 >> $NombreLog;
  apt-get install -y  gdebi 2>&1 >> $NombreLog;

  echo "-> IceTea";
  echo "-> IceTea" >> 2>&1 >> $NombreLog;
  apt-get install -y  icedtea-plugin 2>&1 >> $NombreLog;

  echo "-> TPL (Bateria)";
  echo "-> TPL (Bateria)" >> 2>&1 >> $NombreLog;
  add-apt-repository -y ppa:linrunner/tlp 2>&1 >> $NombreLog;
  apt-get update 2>&1 >> $NombreLog;
  apt-get install -y tlp tlp-rdw 2>&1 >> $NombreLog;
  tlp start 2>&1 >> $NombreLog;

  echo "-> HTOP";
  echo "-> HTOP" >> 2>&1 >> $NombreLog;
  apt-get install -y htop 2>&1 >> $NombreLog;

  echo "-> Wine, PlayOnLinux";
  echo "-> Wine, PlayOnLinux" >> 2>&1 >> $NombreLog;
  apt-get install -y wine-stable playonlinux 2>&1 >> $NombreLog;

  echo "";
  echo "Mantenimiento Post-Instalacion";

  fn_UpdatePrivado;

  echo "";
  echo "< Proceso de Actualizacion Terminado >";
  else
    echo "Debe ser usuario ROOT para ejecutar este Procedimiento";
  fi
}

fn_OpcionesMenu(){
  echo ""
  echo "-- Script de automatiazación y Actualizacion";
  echo "";
  echo "-- Seleccione una de las siguientes opciones";
  echo "-> 1.- Informacion del sistema";
  echo "-> 2.- Informacion Reinicios y Login '$(whoami)'";
  echo "-> 3.- Actualizar Sistema (Automatizado)";
  echo "-> 4.- Instalar Programas Imprescindibles (Automatizado)";
  echo "-> 0.- Cerrar";
  echo "";
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
        1 ) reset; fn_InfoSession; fn_PleaseWait;;
        2 ) reset; fn_UtimosAccesos; fn_PleaseWait;;
        3 ) reset; fn_UpdateSystem; fn_PleaseWait;;
        4 ) reset; fn_InstallSistem; fn_PleaseWait;;
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
