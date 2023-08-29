#!/bin/bash

echo "Istalacao do Zabbix Agent 2 para familia RHEL 8"
sleep 4

if [ -f /etc/yum.repos.d/epel.repo ]; then
        echo "excludepkgs=zabbix*" >>  /etc/yum.repos.d/epel.repo
fi

rpm -Uvh https://repo.zabbix.com/zabbix/6.5/oracle/9/x86_64/zabbix-release-6.5-2.el9.noarch.rpm > /dev/null 2>&1
dnf clean all > /dev/null 2>&1
dnf install -y zabbix-agent2 zabbix-agent2-plugin-postgresql > /dev/null 2>&1 

systemctl enable zabbix-agent2 --now
systemctl status zabbix-aget2
