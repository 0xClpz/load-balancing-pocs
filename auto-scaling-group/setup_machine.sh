#!/bin/sh

# Docker setup
sudo apt-get update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    awscli \
    amazon-ecr-credential-helper \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Docker without sudo
sudo usermod -aG docker $USER
sudo service docker restart

# Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir ~/.docker

cat <<EOF > ~/.docker/config.json
{
	"credsStore": "ecr-login"
}
EOF

cat <<EOF > docker-compose.yml
node-app:
  image: 733047563139.dkr.ecr.eu-west-2.amazonaws.com/node-app:latest
  labels:
    - 'traefik.enable=true'
    - 'traefik.basic.frontend.rule=Host:node-app.tamere.online'
    - 'traefik.basic.port=8080'
    - 'traefik.basic.protocol=http'
traefik:
  image: traefik:1.7
  restart: always
  ports:
    - 80:80
    - 443:443
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - ./traefik.toml:/traefik.toml
    - ./acme.json:/acme.json
EOF

touch acme.json
chmod 600 acme.json

cat <<EOF > traefik.toml
debug = false

logLevel = "ERROR"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
    [entryPoints.https.tls]

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "shippr.io"
watch = true
exposedByDefault = false
network = "default"

[acme]
email = "antonio.root@gmail.com"
storage = "acme.json"
entryPoint = "https"
onHostRule = true

[acme.tlsChallenge]
EOF

# Starts docker compose in a cron, pull and restart every minute
# Continous deployment xD
(crontab -l 2>/dev/null; echo "* * * * * cd /home/ubuntu && /usr/local/bin/docker-compose pull && /usr/local/bin/docker-compose up -d") | crontab -
