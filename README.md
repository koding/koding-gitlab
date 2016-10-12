# Koding and Gitlab Integration

Koding With Gitlab in Google Container Engine

## Creating Koding's Services

Koding depends on RabbitMQ, Postgresql, Redis and Mongo as external services.

* Create redis service

``` kubectl create -f ./redis-standalone ```

* Create rabbitmq service

``` kubectl create -f ./rabbitmq ```

* Create postgresql service

``` kubectl create -f ./postgres-standalone ```

* Create mongo service

``` kubectl create -f ./mongodb ```


## Creating Gitlab's Services

Gitlab depends on Postgresql and Redis as external services.

* We have already created a redis service for koding.
* Create postgresql service

``` kubectl create -f ./gitlab-postgres ```


## Creating Applications

After creating and making sure all the dependant services up and running, run
followings to bootstrap both applications.

Allow services to run before running

``` kubectl create -f ./gitlab ```
``` kubectl create -f ./koding ```

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


## To sum up all the commands we have run above ☝

```
# create resources
terraform apply
# get the credentials
export GOOGLE_APPLICATION_CREDENTIALS=$PWD/account.json
gcloud container clusters get-credentials koding-gitlab --zone us-central1-a
# koding's services
kubectl create -f ./redis-standalone
kubectl create -f ./rabbitmq
kubectl create -f ./postgres-standalone
kubectl create -f ./mongodb
#gitlab's services
kubectl create -f ./gitlab-postgres
#create the applications
kubectl create -f ./gitlab
kubectl create -f ./koding
```


## Integrating Gitlab and Koding together

* Create an Oauth application under gitlab https://docs.gitlab.com/ee/integration/oauth_provider.html
* Add your integration under Koding Account Settings > Integrations > Gitlab https://cloudup.com/ccXzsE9W2FB
* Enable your access to Gitlab under Koding Account Settings > My Account > Integrations > Gitlab https://cloudup.com/cxENunwQ_kR
* Have your koding.yaml in your repo https://cloudup.com/cKaN5KnW6gq
* You will see Run on Koding https://cloudup.com/iqcjUX5q5Fy


## Misc

You can see cluster init docs here [CLUSTER](./CLUSTER.md)
You can see debugging info here [DEBUGGING](./DEBUGGING.md)
