#!/bin/bash
##########################################################################################
## Author: Black-Zeus                                                                  ###
## Created: 2018-09-25                                                                 ###
## Description: Este Script genera un Menu base para la Aplicacion de diversas         ###
##              funciones de mantenimiento y automatiazación                           ###
##########################################################################################

##########################################################################################
### Boque de Presentacion                                                              ###
##########################################################################################
fn_banner() {
    if hash figlet 2>/dev/null; then
        figlet Black-Zeus
    else
        if fn_checkroot_Bool; then
          apt-get install -y figlet  2>&1 >> /dev/null;
          figlet Black-Zeus
        else
          echo "-------------------";
          echo "--  Back - Zeus  --";
          echo "-------------------";
        fi
    fi

    ### Datos del Banner ##
    echo "-------------------------------------";
    echo "-- Script de Automatizacion v0.1 Beta";
    echo "-------------------------------------";
    echo "";
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
  echo "-> 5.- Desbloqueo para instalacion y Actualizacion";
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
  echo "-- Hora Encendido: $(uptime -s)";
  echo "-- Horas Encendido: $(uptime -p)";
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
### Bloque Seccion: Informacion Reinicios y Login                                      ###
##########################################################################################
fn_UtimosAccesos(){
  clear

  ### Datos Ultimos 5 Accesos
  echo "-------------------------------------";
  echo "-- Ultimos 5 Accesos                 ";
  echo "-------------------------------------";
  last -5 -diwx $USER

  if fn_checkroot_Bool; then
	echo "-------------------------------------";
	echo "-- Ultimos 5 Accesos Fallidos        ";
	echo "-------------------------------------";
	last -5 -diwx $USER
  fi

  ### Datos Ultimos 5 Accesos
  echo "-------------------------------------";
  echo "-- Ultimos 5 Reinicios               ";
  echo "-------------------------------------";
  last reboot -F | head -5

  ### Listado de Usuario del sistema
  fn_GetAllUser;
}

fn_GetAllUser(){
	#######################################################################################################
	# Este bloque se extrae desde https://www.cyberciti.biz/faq/linux-list-users-command/                 #
	# Name: listusers.bash                                                                                #
	# Purpose: List all normal user and system accounts in the system. Tested on RHEL / Debian Linux      #
	# Author: Vivek Gite <www.cyberciti.biz>, under GPL v2.0+                                             #
	#######################################################################################################

	_l="/etc/login.defs"
	_p="/etc/passwd"

	## get mini UID limit ##
	l=$(grep "^UID_MIN" $_l)

	## get max UID limit ##
	l1=$(grep "^UID_MAX" $_l)

  echo "";
	echo "-------------------------------------";
	echo "-- Usuarios del Sistema               ";
	echo "-------------------------------------";

	## use awk to print if UID >= $MIN and UID <= $MAX and shell is not /sbin/nologin   ##
	echo ">> Usuarios Normales"
	awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $0 }' "$_p"

	## echo ""
	## echo "----------[ Cuentas de Usuarios del Sistema ]---------------"
	## awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( !($3 >= min && $3 <= max  && $7 != "/sbin/nologin")) print $0 }' "$_p"
}

##########################################################################################
### Bloque Seccion: Actualizar Sistema (Automatizado)                                  ###
##########################################################################################
fn_UpdatePrivado(){
  echo "";
  echo "Actualizando Repositorios 'apt-get update'";
  echo "Actualizando Repositorios 'apt-get update'" >> $NombreLog 2>&1;

  echo "-> Update";
  echo "-> Update" >> $NombreLog 2>&1;
  apt-get update >> $NombreLog 2>&1;

  echo "";
  echo "Actualizando Sistema";
  echo "Actualizando Sistema" >> $NombreLog;

  echo "-> Upgrade";
  echo "-> Upgrade" >> $NombreLog 2>&1;
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

fn_UnLock(){
  if fn_checkroot_Bool; then
  NombreLog="Log_Actualiza_"$(date +"%Y%m%d")."txt"
  rm -rf $NombreLog 2>&1;

  echo "-------------------------------------";
  echo "-- Quitar Bloqueo para instalacion   ";
  echo "-------------------------------------";

  fuser -vki  /var/lib/dpkg/lock
  rm -f /var/lib/dpkg/lock
  dpkg --configure -a
  apt-get auto-remove
  apt-get auto-clean

  echo "";
  echo "< Proceso de Desbloqueo Terminado >";
  else
    echo "Debe ser usuario ROOT para ejecutar este Procedimiento"
  fi
}

##########################################################################################
### Bloque Seccion: Instalar Programas Imprescindibles                                 ###
##########################################################################################
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
  apt-get -y install ubuntu-restricted-extras >> $NombreLog 2>&1;

  echo "-> Compresores";
  echo "-> Compresores" >> $NombreLog 2>&1;
  apt-get install -y unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip 2>&1 >> $NombreLog;

  echo "-> VLC";
  echo "-> VLC" >> $NombreLog 2>&1;
  apt-get install -y vlc 2>&1 >> $NombreLog;

  #echo "-> Java";
  #echo "-> Java" >> $NombreLog 2>&1;
  #apt-get purge -y openjdk* 2>&1 >> $NombreLog;
  #add-apt-repository -y ppa:webupd8team/java 2>&1 >> $NombreLog;
  #apt-get update 2>&1 >> $NombreLog;
  #apt-get install -y oracle-java8-set-default openjdk-8-jre 2>&1 >> $NombreLog;

  echo "-> Gdebi";
  echo "-> Gdebi" >> $NombreLog 2>&1;
  apt-get install -y  gdebi 2>&1 >> $NombreLog;

  echo "-> IceTea";
  echo "-> IceTea" >> $NombreLog 2>&1;
  apt-get install -y  icedtea-plugin 2>&1 >> $NombreLog;

  #echo "-> TPL (Bateria)";
  #echo "-> TPL (Bateria)" >> $NombreLog 2>&1;
  #add-apt-repository -y ppa:linrunner/tlp 2>&1 >> $NombreLog;
  #apt-get update 2>&1 >> $NombreLog;
  #apt-get install -y tlp tlp-rdw 2>&1 >> $NombreLog;
  #tlp start 2>&1 >> $NombreLog;

  echo "-> HTOP";
  echo "-> HTOP" >> $NombreLog 2>&1;
  apt-get install -y htop 2>&1 >> $NombreLog;

  echo "-> Wine, PlayOnLinux";
  echo "-> Wine, PlayOnLinux" >> $NombreLog 2>&1;
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
        5 ) reset; fn_UnLock; fn_PleaseWait;;
        0 ) fn_SalirBash; exit;;
        * ) fn_OPcionErronea; fn_PleaseWait;;
      esac
    done
}

##########################################################################################
### Bloque Seccion: Llamada al Menu                                                    ###
##########################################################################################
reset
display_main_menu;
