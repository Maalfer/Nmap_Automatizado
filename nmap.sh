#!/bin/bash

test -f /usr/bin/nmap
if [ "$(echo $?)" == "0" ]; then
	echo "Las dependencias están satisfechas"
else
	echo "Hay que instalar dependencias" && apt update >/dev/null && apt install nmap -y >/dev/null && echo "Dependencias instaladas"
fi

ip=$1

nmap -p- -sCV --open -sS --min-rate 5000 -n -Pn $ip -oN escaneo
