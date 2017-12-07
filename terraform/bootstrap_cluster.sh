#/bin/bash
#bootstrap_cluster script to get around terraforms lack of module dependencies.

terraform plan -out=terraform.plan -target=module.wireguard -target=module.firewall && \
terraform apply terraform.plan && \
terraform plan -out terraform.plan -target=module.docker && \
terraform apply terraform.plan && \
terraform plan -out terraform.plan -target=module.kubectl -target=module.kubelet_kubeadm && \
terraform apply terraform.plan && \
terraform plan -out terraform.plan -target=module.master && \
terraform apply terraform.plan && \
terraform plan -out terraform.plan && \
terraform apply terraform.plan && \
rm terraform.plan
