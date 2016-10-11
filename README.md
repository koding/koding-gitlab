# koding-gitlab
Koding With Gitlab in Google Container Engine

## Prerequites

1) Get an Google Cloud Account [link](https://cloud.google.com/storage/docs/cloud-console)
2) Install Terraform [here](https://www.terraform.io/intro/getting-started/install.html)

## Creating the Kubernetes Cluster - Google Cloud Platform

This readme will walk you through provisioning the compute instances required
for running a H/A Kubernetes cluster. A total of 3 virtual machines will be
created.


```
gcloud compute instances list
```

````
NAME                                          ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP       STATUS
gke-koding-gitlab-default-pool-bcdd9e1e-klss  us-central1-a  n1-standard-2               10.128.0.4   xxx.xxx.xxx.xxx   RUNNING
gke-koding-gitlab-default-pool-bcdd9e1e-ou0l  us-central1-a  n1-standard-2               10.128.0.3   xxx.xxx.xxx.xxx   RUNNING
gke-koding-gitlab-default-pool-bcdd9e1e-p5s9  us-central1-a  n1-standard-2               10.128.0.2   xxx.xxx.xxx.xxx   RUNNING
````

### Networking

Set the region and zone
Create a Kubernetes network
Create a subnet for the Kubernetes cluster

### Firewall Rules

allow-icmp source-ranges 0.0.0.0/0
allow-internal source-ranges 10.240.0.0/24
allow-rdp source-ranges 0.0.0.0/0
allow-ssh source-ranges 0.0.0.0/0
allow-healthz source-ranges 130.211.0.0/22
allow-api-server source-ranges 0.0.0.0/0


```
gcloud compute firewall-rules list --filter "network=koding-gitlab"
```

```
NAME                                            NETWORK        SRC_RANGES          RULES                         SRC_TAGS  TARGET_TAGS
gke-koding-gitlab-52165f95-all                  koding-gitlab  10.1.0.0/16         icmp,esp,ah,sctp,tcp,udp
gke-koding-gitlab-52165f95-ssh                  koding-gitlab  104.198.209.203/32  tcp:22                                  gke-koding-gitlab-52165f95-node
gke-koding-gitlab-52165f95-vms                  koding-gitlab  10.128.0.0/20       tcp:1-65535,udp:1-65535,icmp            gke-koding-gitlab-52165f95-node
koding-gitlab-kubernetes-allow-api-server       koding-gitlab  0.0.0.0/0           tcp:6443
koding-gitlab-kubernetes-allow-from-current     koding-gitlab  127.0.0.1/32        tcp:0-65535
koding-gitlab-kubernetes-allow-healthz          koding-gitlab  130.211.0.0/22      tcp:8080
koding-gitlab-kubernetes-allow-icmp             koding-gitlab  0.0.0.0/0           icmp
koding-gitlab-kubernetes-allow-internal         koding-gitlab  10.128.0.0/20       icmp,tcp:0-65535,udp:0-65535
koding-gitlab-kubernetes-allow-koding-endpoint  koding-gitlab  0.0.0.0/0           tcp:8090
koding-gitlab-kubernetes-allow-rdp              koding-gitlab  0.0.0.0/0           tcp:3389
koding-gitlab-kubernetes-allow-ssh              koding-gitlab  0.0.0.0/0           tcp:22
```


### Provision Resources

To simplify provisioning mentioned resources, we will use Terraform.
You should have it in your PATH.

``` terraform apply ```

### Configure your env
Set your google account files adress to ENV var

``` GOOGLE_APPLICATION_CREDENTIALS=$pwd/account.json ```

### Getting credentials for your cluster

```
gcloud container clusters get-credentials <cluster name> \
    --zone <zone name> --project <project name>
```

### Reaching To Kubernetes UI

Just proxy your localhost to kubernetes service after getting your credentials

```
kubectl proxy
Starting to serve on 127.0.0.1:8001
```

## Creating Koding Services

Koding depends on RabbitMQ, Posgresql, Redis and Mongo as external services.

* Create redis service

``` kubectl create -f ./redis-standalone ```

* Create rabbitmq service

``` kubectl create -f ./rabbitmq ```

* Create postgresql service

``` kubectl create -f ./postgres-standalone ```

* Create postgresql service

``` kubectl create -f ./mongodb ```


## Configuring DNS Records

### Configuring Koding service

```
kubectl get svc koding -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
xxx.xxx.xxx.xxx%
```


Add this ip with the same name of your config in koding/deployment.yaml's config
```
- "--hostname"
- "dev.savas.io"
- "--host"
- "dev.savas.io"
- "--publicPort"
```


### Configuring Gitlab service
```
kubectl get svc gitlab -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
xxx.xxx.xxx.xxx%
```

Add this ip with the same name of your config in gitlab/gitlab-rc.yaml's config.
```
GITLAB_HOST
```


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
