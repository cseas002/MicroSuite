for node in node2 node1 node0
do
  ssh $node "curl -fsSL https://get.docker.com -o get-docker.sh; DRY_RUN=1 sh ./get-docker.sh; sudo sh get-docker.sh; sudo apt -y install docker-compose"
  ssh $node "sudo apt -y install gnupg2 pass"
  ssh $node "sudo docker rm -f $(docker ps -aq); docker rmi -f $(docker images -q); sudo systemctl stop docker; umount /var/lib/docker; sudo rm -rf /var/lib/docker"
  ssh $node "sudo mkdir /var/lib/docker; sudo mkdir /dev/mkdocker; sudo mount --rbind /dev/mkdocker /var/lib/docker; sudo systemctl start docker"
done

for node in node1 node2
do
    ssh $node "mkdir MicroSuite"
done


# sudo docker rm -f $(docker ps -aq); docker rmi -f $(docker images -q)
# sudo systemctl stop docker
# umount /var/lib/docker # THIS DOESN'T WORK
# sudo rm -rf /var/lib/docker
# sudo mkdir /var/lib/docker
# sudo mkdir /dev/mkdocker
# sudo mount --rbind /dev/mkdocker /var/lib/docker
# sudo systemctl start docker
# sudo newgrp docker
# sudo docker compose up

parallel-ssh -H "node0 node1 node2" -i "cd ~/MicroSuite && sudo docker-compose down"
cd ~/MicroSuite && sudo wget https://akshithasriraman.eecs.umich.edu/dataset/HDSearch/image_feature_vectors.dat
sudo docker swarm init --advertise-addr 10.10.1.1

parallel-ssh -H "node1" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
parallel-ssh -H "node2" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"

export NODE0=$(ssh node0 hostname)
export NODE1=$(ssh node1 hostname)
export NODE2=$(ssh node2 hostname)

cd ~/MicroSuite


# Install dependencies
# for node in node2 node1 node0
# do
#     ssh $node "sudo apt-get install -y linux-tools-generic; sudo apt-get install -y linux-cloud-tools-generic; sudo apt-get install -y linux-tools-5.4.0-164-generic; sudo apt-get install -y linux-cloud-tools-5.4.0-164-generic"
# done

# Here, create the script to run it 
sudo docker stack deploy --compose-file=docker-compose-swarm.yml microsuite