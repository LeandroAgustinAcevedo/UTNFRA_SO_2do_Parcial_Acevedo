#!/bin/bash

echo "Ingrese un usuario: "
read usuario
PASSWORD="$(sudo grep $usuario: /etc/shadow | awk -F':' '{print $2}')"

echo "Ingrese el path de la lista: "
read path
LISTA="$(grep -v '#' $path)"

for linea in $LISTA; do
	IFS=',' read -r nombre grupo directorio <<< "$linea"
	if ! grep -q "$grupo:" /etc/group; then
		sudo groupadd "$grupo"
	fi
	sudo useradd -m -s /bin/bash -d "$directorio" -G "$grupo" -p "$PASSWORD" "$nombre"
done

