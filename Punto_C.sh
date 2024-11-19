#!/bin/bash
sudo usermod -a -G docker $(whoami)

if ! sudo systemctl status docker | grep -q "Active: active (running)"; then
        sudo systemctl enable --now docker
fi

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

docker run -d -p 8080:80 -v "$PWD/index.html:/usr/share/nginx/html/index.html" nginx
ID="$(docker ps | tail -n1 | awk '{print $1}')"

docker commit "$ID" web1-Acevedo
docker login -u leandroagustinacevedo
docker push leandroagustinacevedo/web1-acevedo

cat << EOF > run.sh
#!/bin/bash
docker run -d -p 8080:80 leandroagustinacevedo/web1-acevedo
EOF
chmod 755 run.sh

