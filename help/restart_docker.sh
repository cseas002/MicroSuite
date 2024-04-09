sudo docker stack rm microsuite

ssh node1 "sudo docker swarm leave"
ssh node2 "sudo docker swarm leave"
sudo docker swarm leave --force

sudo docker swarm init --advertise-addr 10.10.1.1

parallel-ssh -H "node1" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
parallel-ssh -H "node2" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
export NODE0=$(ssh node0 hostname)
export NODE1=$(ssh node1 hostname)
export NODE2=$(ssh node2 hostname)

cd
sudo docker stack deploy --compose-file=docker-compose-swarm.yml microsuite