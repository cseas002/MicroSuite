sudo docker swarm init --advertise-addr 10.10.1.1

parallel-ssh -H "node1" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
parallel-ssh -H "node2" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
export NODE0=$(ssh node0 hostname)
export NODE1=$(ssh node1 hostname)
export NODE2=$(ssh node2 hostname)


# To remove (stop the processes)
sudo docker stack rm microsuite

# Wait a little bit

# To run
sudo docker stack deploy --compose-file=docker-compose-swarm.yml microsuite

# To change the experiment, change the yml. e.g. for setalgebra, run
sudo docker stack deploy --compose-file=docker-compose-swarm-setalgebra.yml microsuite

# After running the experiment, save the log files (it doesn't save them automatically)


# To check
sudo docker stack ps microsuite

# For logs
sudo docker service logs --raw microsuite_midtier  # (or _midtier, _client)