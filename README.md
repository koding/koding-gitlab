# Koding and Gitlab Integration

Koding With Gitlab with scalable Kubernetes Backend

## This will run Gitlab and Koding together

```bash
# create resources
terraform apply
# get the credentials - required only if you are on GCE
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

ENJOY!

* Have your koding.yaml in your repo https://cloudup.com/cKaN5KnW6gq
* You will see Run on Koding https://cloudup.com/iqcjUX5q5Fy


## Misc

* Configure your DNS records according to following [README](./DNS.md)
* You can see cluster init docs here [CLUSTER](./CLUSTER.md)
* You can see debugging info here [DEBUGGING](./DEBUGGING.md)
