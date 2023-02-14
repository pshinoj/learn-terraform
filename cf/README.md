# Instructions
## 1. Structure terraform project
```bash
├── README.md
├── main.tf
├── modules
│   ├── cf_app
│   │   ├── app.tf
│   │   ├── target
│   │   │   └── microservice1-1.0.0.jar
│   │   └── variables.tf
│   └── cf_vault
│       ├── variables.tf
│       └── vault.tf
├── outputs.tf
├── secrets.json
├── terraform.tfvars
└── variables.tf
```
## 2. Initialize terraform project
```bash
$ terraform init
```

## 3. Plan with an external secret tfvars
Add CF credentials to a dedicated `tfvars` file and pass it along with the plan.

**NOTE:** DO NOT check in your credentials to git repo
```bash
$ tf plan -var-file=.secrets.tfvars
```

## 4. Split the plan into two 
If you have a situation where a sub-module input can be passed only if a parent module resource is created, then the overall plan will not work! You need to split the plan into two

**Stage1**
```bash
$ tf plan -var-file=.secrets.tfvars -target=cloudfoundry_service_key.myvault_key -out stage1.out
```
```bash
$ tf apply "stage1.out" -auto-approve
```

**Stage2**
```bash
$ tf plan -var-file=.secrets.tfvars -out=stage2.out
```
```bash
$ tf apply "stage2.out" -auto-approve
```

**Without stage**

Once the vault service is successfully created, you can run `apply` without splitting the plan into multiple stages

```bash
$ tf apply --auto-approve -var-file=.secrets.tfvars
```

## Finally destroy resources
```bash
$ tf destroy -auto-approve -var-file=.secrets.tfvars
```

## References
[Terraform Plan](https://developer.hashicorp.com/terraform/cli/commands/plan)

