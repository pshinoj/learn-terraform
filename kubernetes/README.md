# Instructions
## 1. Structure terraform project
```bash
├── README.md
├── main.tf
├── modules
│   ├── app
│   │   ├── app.tf
│   │   └── variables.tf
│   ├── kubegres
│   │   ├── kubegres.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── nginx
│       ├── nginx.tf
│       └── variables.tf
├── terraform.tfvars
└── variables.tf
```
## 2. Initialize terraform project
```bash
$ terraform init
```

## 3. Configure terraform variables
Add docker registry credentials where the service container image is available for download.

**NOTE:** DO NOT check in your credentials to git repo

## 4. Split the plan into two 
If you have a situation where a sub-module input can be passed only if a parent module resource is created, then the overall plan will not work! You need to split the plan into two

**Stage1**
```bash
$ tf plan -target=null_resource.kubectl_kubegres -out stage1.out
```
```bash
$ tf apply "stage1.out" -auto-approve
```

**Stage2**
Run the plan with all targets
```bash
$ tf plan 
```
```bash
$ tf apply -auto-approve
```
This should endup creating the kubernetes resources like pods, replicasets, services etc. under a dedicated namespace called `tutorial`

Verify if the resources exist
```bash
$ kubectl get all -n=tutorial

# You shall get a response like this:
NAME                                      READY   STATUS    RESTARTS     AGE
pod/tutorial-demo-app-7475c97f84-kmx5c    1/1     Running   1 (8s ago)   8s
pod/tutorial-app-nginx-8499c59f9d-vpkln   1/1     Running   1 (8s ago)   8s
pod/tutorial-demo-app-7475c97f84-b7pbv    1/1     Running   1 (8s ago)   8s
pod/tutorial-postgres-1-0                 1/1     Running   1 (8s ago)   8s
pod/tutorial-postgres-2-0                 1/1     Running   1 (8s ago)   8s
pod/tutorial-postgres-4-0                 1/1     Running   0            8s

NAME                                TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)          AGE
service/tutorial-app-nginx          LoadBalancer   10.43.45.219   192.168.64.19   9002:31730/TCP   8s
service/tutorial-demo-app           LoadBalancer   10.43.25.101   192.168.64.19   9080:31697/TCP   8s
service/tutorial-postgres           ClusterIP      None           <none>          5432/TCP         8s
service/tutorial-postgres-replica   ClusterIP      None           <none>          5432/TCP         8s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/tutorial-app-nginx   1/1     1            1           8s
deployment.apps/tutorial-demo-app    2/2     2            2           8s

NAME                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/tutorial-app-nginx-8499c59f9d   1         1         1       8s
replicaset.apps/tutorial-demo-app-7475c97f84    2         2         2       8s

NAME                                   READY   AGE
statefulset.apps/tutorial-postgres-1   1/1     8s
statefulset.apps/tutorial-postgres-2   1/1     8s
statefulset.apps/tutorial-postgres-4   1/1     8s
```

## Verify if the service is up and running
Use the external IP configured for `tutorial-demo-app`
```bash
$ http://192.168.64.19:9080/version
```

## Finally destroy resources
```bash
$ tf destroy -auto-approve -var-file=.secrets.tfvars
```

## References
[Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)

