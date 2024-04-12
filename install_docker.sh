#!/bin/bash

for node in node2 node1 node0
do
  ssh $node 'sudo apt-get update;
            sudo apt -y install jq;
            sudo apt-get install ca-certificates curl;
            sudo install -m 0755 -d /etc/apt/keyrings;
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc;
            sudo chmod a+r /etc/apt/keyrings/docker.asc;

            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
            sudo apt-get update;

            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;

            docker --version;

            sudo chown $USER:docker /var/run/docker.sock;
            sudo chmod 660 /var/run/docker.sock';
done