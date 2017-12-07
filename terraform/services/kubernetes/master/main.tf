resource "null_resource" "master" {
  count = "${var.count}"

  triggers = {
    masters_count = "${var.count}"
  }

  connection {
    host        = "${element(var.connections, count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = <<EOF
kubeadm reset
kubeadm init \
--kubernetes-version=v1.8.0 \
--apiserver-advertise-address=${element(var.vpn_ips, count.index)} \
--apiserver-bind-port=${var.kubernetes_api_port} \
--apiserver-cert-extra-sans=${element(var.vpn_ips, count.index)},${var.domain},${element(var.public_ips, count.index)} \
--pod-network-cidr=10.244.0.0/16 \
--token=${var.token}
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
EOF
  }

  provisioner "file" {
    source      = "../manifests/kube-flannel-ds.yaml"
    destination = "/tmp/flannel-ds.yaml"
  }

  provisioner "remote-exec" {
    inline = "kubectl apply -f /tmp/flannel-ds.yaml"
  }
}
