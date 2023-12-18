#!/bin/bash

echo "Instalando Docker"

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker

echo "Instalando Docker Compose"
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# *** YOUR CODE HERE ***
# Lanzar un contenedor de esta forma:
# - Modo detached a partir de la imagen ualmtorres/books-api:v0
# - Mapear el puerto 80 con el puerto 3000 del contenedor
# - Configurar estas variables de entorno
#   - TUTORIAL_HOST=<direccion-ip-fija-instancia-MySQL> 
#   - TUTORIAL_PORT=3306 
#   - TUTORIAL_USER=sg
#   - TUTORIAL_PASSWORD=my_password
#   - TUTORIAL_DATABASE=SG 

echo "Iniciando sesión en Docker Hub"
docker login -u ecg578 -p ubuntuubuntu

echo "Levantando Docker"
docker run -d --name books-api -p 80:3000 -e TUTORIAL_HOST=${mysql_ip} -e TUTORIAL_PORT=3306 -e TUTORIAL_USER=sg -e TUTORIAL_PASSWORD=my_password -e TUTORIAL_DATABASE=SG ualmtorres/books-api:v0
# **********************

exit 0