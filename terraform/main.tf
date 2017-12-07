module "provider" {
  source = "./provider/linode"

  linode_api_key = "${var.linode_api_key}"
  root_password  = "${var.root_password}"
  public_key     = "${file(var.public_key_path)}"

  count           = "${var.worker_count + var.master_count}"
  hostname_format = "${var.hostname_format}"
}

module "wireguard" {
  source = "./security/wireguard"

  count       = "${var.worker_count + var.master_count}"
  connections = "${module.provider.public_ips}"
  private_ips = "${module.provider.private_ips}"
  hostnames   = "${module.provider.hostnames}"
  private_key = "${file(var.private_key_path)}"
}

module "firewall" {
  source = "./security/iptables"

  count               = "${var.worker_count + var.master_count}"
  connections         = "${module.provider.public_ips}"
  private_ips         = "${module.provider.private_ips}"
  private_interface   = "${module.provider.private_network_interface}"
  vpn_interface       = "${module.wireguard.vpn_interface}"
  vpn_port            = "${module.wireguard.vpn_port}"
  kubernetes_api_port = "${var.kubernetes_api_port}"

  private_key = "${file(var.private_key_path)}"
}

module "docker" {
  source = "./services/docker"

  count       = "${var.worker_count + var.master_count}"
  connections = "${module.provider.public_ips}"
  private_key = "${file(var.private_key_path)}"
}

module "kubelet_kubeadm" {
  source = "./services/kubernetes/kubelet_kubeadm"

  count       = "${var.master_count + var.worker_count}"
  connections = "${module.provider.public_ips}"
  private_key = "${file(var.private_key_path)}"
}

module "master" {
  source = "./services/kubernetes/master"

  count               = "${var.master_count}"
  connections         = "${module.provider.public_ips}"
  private_key         = "${file(var.private_key_path)}"
  public_ips          = "${module.provider.public_ips}"
  vpn_ips             = "${module.wireguard.vpn_ips}"
  token               = "${var.token}"
  domain              = "${var.domain}"
  kubernetes_api_port = "${var.kubernetes_api_port}"
}

module "node" {
  source = "./services/kubernetes/node"

  master_count        = "${var.master_count}"
  worker_count        = "${var.worker_count}"
  connections         = "${module.provider.public_ips}"
  private_key         = "${file(var.private_key_path)}"
  token               = "${var.token}"
  master_ip           = "${element(module.wireguard.vpn_ips, 0)}"
  kubernetes_api_port = "${var.kubernetes_api_port}"
}
