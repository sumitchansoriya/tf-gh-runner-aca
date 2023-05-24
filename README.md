
```bash
terraform init

terraform plan \
  -var="org=sup" \
  -var="project=devops" \
  -var="runner_token=XXX" \
  -var="runner_group_name=hogwarts-houses" \
  -var="github_organisation=deanchin"

terraform apply \
  -auto-approve \
  -var="org=sup" \
  -var="project=devops" \
  -var="runner_token=XXX" \
  -var="runner_group_name=hogwarts-houses" \
  -var="github_organisation=deanchin"

terraform destroy \
  -auto-approve \
  -var="org=sup" \
  -var="project=devops" \
  -var="runner_token=XXX" \
  -var="runner_group_name=hogwarts-houses" \
  -var="github_organisation=deanchin"
```

## Other commands

```bash
tflint
terraform fmt
```

