#!/bin/bash
sudo usermod -a -G docker $(whoami)
cd $HOME
cd UTN-FRA_SO_Examenes/202406/docker/
cat << EOF > index.html
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Noviembre 2024 </h2> </br>
<h3> Leandro Acevedo</h3>
<h3> División: 115</h3>
</div>
EOF
if ! sudo systemctl status docker | grep -q "Active: active (running)"; then
	sudo systemctl enable --now docker
fi
docker run -d -p 8080:80 -v "$PWD/index.html:/usr/share/nginx/html/index.html" nginx
docker ps | tail -n1

