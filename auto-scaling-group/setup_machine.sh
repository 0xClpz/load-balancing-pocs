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

(crontab -l 2>/dev/null; echo "* * * * * cd /home/ubuntu && /usr/local/bin/docker-compose pull && /usr/local/bin/docker-compose up -d") | crontab -

cat <<EOF > docker-compose.yml
node-app:
  image: 733047563139.dkr.ecr.eu-west-2.amazonaws.com/node-app:latest
  ports:
    - 80:8080
EOF
