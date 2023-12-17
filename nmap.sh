#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

nmaptest() {
  
  dep=(nmap whatweb)
  for i in "$dep[@]"; do
    test -f /usr/bin/$i
    if [ "$(echo $?)" -ne 0 ]; then
      sudo apt-get install $i -y > /dev/null 2>&1
      if [ "$(echo $?)" -ne 0 ]; then
        sudo dnf install $i -y > /dev/null 2>&1
      elif [ "$(echo $?)" -ne 0 ]; then
        sudo pacman -S $i -y > /dev/null 2>&1
      fi
    fi
  done
}

enter(){
  
  echo -ne "\n\n${greenColour}[!]$grayColour Enter para continuar" && read
  clear
  tput cnorm
}

iptest() {
  clear
  echo -ne "$greenColour\n[?]$grayColour Introduce la IP: " && read ip
  ping -c 1 $ip | grep "ttl" > /dev/null 2>&1
  if [ "$(echo $?)" -ne 0 ]; then
    echo -e "$redColour[!]$grayColour No se encuentra activa la IP"; sleep 3
    iptest
  fi
}

if [ $(id -u) -ne 0 ]; then
	echo -e "\n$redColour[!]$grayColour Debes ser root para ejecutar el script -> (sudo $0)"
exit 1
else
    nmaptest
    clear
    iptest
    while true; do
      echo -e "\n\n1) Escaneo rapido pero ruidoso"
      echo "2) Escaneo Normal"
      echo "3) Escaneo silencioso (Puede tardar un poco mas de lo normal)"
      echo "4) Escaneo de serviciosos y versiones"
      echo "5) WhatWeb"
      echo "6) Salir"
      echo -ne "$greenColour\n[?]$grayColour Seleccione una opcion: " && read opcion
      case $opcion in
       1)
       tput civis 
       clear && echo -ne "\n${greenColour}[+]${grayColour} Escaneando...\n\n" && nmap -p- --open --min-rate 5000 -T5 -sS -Pn -n -v $ip | grep -E "^[0-9]+\/[a-z]+\s+open\s+[a-z]+"
       enter
       ;;
       2)
       tput civis
       clear && echo -ne "\n${greenColour}[+]${grayColour} Escaneando...\n\n" && nmap -p- --open $ip | grep -E "^[0-9]+\/[a-z]+\s+open\s+[a-z]+"
       enter
       ;;
       3)
       tput civis
       clear && echo -ne "\n${greenColour}[+]${grayColour} Escaneando...\n\n" && nmap -p- -T2 -sS -Pn -f $ip | grep -E "^[0-9]+\/[a-z]+\s+open\s+[a-z]+"
       enter
       ;;
       4)
       tput civis
       clear && echo -ne "\n${greenColour}[+]${grayColour} Escaneando...\n\n" && nmap -sV -sC $ip		
       enter
       ;;
       5)
       tput civis
       clear && echo -ne "\n${greenColour}[+]${grayColour} Escaneando...\n\n" && whatweb $ip
       enter
       ;;
       6)
       break
       ;;
       *)
        echo -e "\n$redColour[!]$grayColour Opcion no encontrada"
        ;;
      esac
    done
fi

finish() {
    echo -e "\n$redColour[!]$grayColour Cerrando el script..."
    exit 
}

trap finish SIGINT