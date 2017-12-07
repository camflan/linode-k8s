#!/bin/sh
set -e

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -F

for i in ${private_ips}; do
iptables -A INPUT -p tcp -s $i -j ACCEPT
iptables -A INPUT -p udp -s $i -j ACCEPT
done

iptables -A INPUT -i ${vpn_interface} -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p udp --dport 80 -j ACCEPT

iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p udp --dport 443 -j ACCEPT

iptables -A INPUT -p tcp --dport ${kubernetes_api_port} -j ACCEPT
iptables -A INPUT -p udp --dport ${kubernetes_api_port} -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT -m comment --comment "Allow all loopback traffic"
iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT -m comment --comment "Drop all traffic to 127 that doesn't use lo"
