## Debugging services


Debugging Mongo

```
mongoHost=$(kubectl get pods -l name=mongo -o jsonpath="{.items[0].spec.nodeName}")
gcloud compute ssh $mongoHost --zone us-central1-a
docker ps -a |  grep mongo
docker exec -it cf6ab59e6304 bash
mongo --eval="printjson(rs.isMaster())"
```

Debugging RabbitMQ
```
rabbitMq=$(kubectl get pods -l provider=rabbitmq -o jsonpath="{.items[0].spec.nodeName}")
gcloud compute ssh $rabbitMq --zone us-central1-a
docker ps -a |  grep rabbitmq:3
docker exec -it cf6ab59e6304 bash
rabbitmqctl status
```


Debugging Postgres
```
# check postgres replication is running
postgresHost=$(kubectl get pods postgresql-master -o jsonpath="{.spec.nodeName}")
gcloud compute ssh $postgresHost --zone us-central1-a
docker ps -a |  grep postgres
docker exec -it cf6ab59e6304 bash

psql -U postgres postgres -c 'table pg_stat_replication'
```


Debugging Redis
```
# check redis replication is running
redisHost=$(kubectl get pods -l name=redis -o jsonpath="{.items[0].spec.nodeName}")
gcloud compute ssh $redisHost --zone us-central1-a
docker ps -a |  grep redis:v1
docker exec -it cf6ab59e6304 bash

root@redis-master:/data# redis-cli info | grep slave
connected_slaves:2
slave0:ip=10.1.1.29,port=6379,state=online,offset=12054733,lag=0
slave1:ip=10.1.2.34,port=6379,state=online,offset=12054600,lag=1

```
