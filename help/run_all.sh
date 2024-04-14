#!/bin/bash

for send_request_time in -1 0 50 100 150 200
do
    sed -i "s/send_request_time = .*/send_request_time = $send_request_time;/" ~/MicroSuite/src/Router/mid_tier_service/service/mid_tier_server.cc


    for experiment in {1..5}
    do
        export NODE0=$(ssh node0 hostname)
        export NODE1=$(ssh node1 hostname)
        export NODE2=$(ssh node2 hostname)
        sudo docker stack rm microsuite

        ssh node1 "sudo docker swarm leave"
        ssh node2 "sudo docker swarm leave"
        sudo docker swarm leave --force

        parallel-ssh -H "node0 node1 node2" -i "cd ~/MicroSuite && sudo docker-compose down"
        sudo docker swarm init --advertise-addr 10.10.1.1

        parallel-ssh -H "node1" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"
        parallel-ssh -H "node2" -i "sudo docker swarm join --token `sudo docker swarm join-token worker -q` 10.10.1.1:2377"


        scp ~/MicroSuite/src/Router/mid_tier_service/service/mid_tier_server.cc node1:~/MicroSuite/mid_tier_server.cc


        ssh -A node2 "pkill \"server\""
        gcc ~/MicroSuite/src/server.c -o ~/MicroSuite/src/server
        scp ~/MicroSuite/src/server node2:~/

        ssh -A node2 "nohup taskset -c 1 ./server > server_node2.log 2>&1 & disown" &
        scp ~/MicroSuite/src/server.c node2:~/MicroSuite/


        cd ~/MicroSuite
        # sudo docker stack deploy --compose-file=docker-compose-swarm.yml microsuite
        docker stack deploy --compose-file=docker-compose-swarm-router.yml microsuite

        sleep 300
        sudo docker service logs --raw microsuite_client | tail -n 3 | head -n 2 >> ./results/results_$send_request_time.txt
    done
done