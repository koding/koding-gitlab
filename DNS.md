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

