#!/bin/bash

echo "Instalacao do Zabbix Proxy para familia RHEL 8"

echo "O PostgreSQL inslatado? [Y/n] "
read var

if [ $var = "n" ]; then
    echo "Necessario instalar o Postegresql antes!"
    echo "Encerrando..."
    sleep 2
    exit 1
fi

echo "Instalando repo..."
rpm -Uvh https://repo.zabbix.com/zabbix/6.5/rhel/8/x86_64/zabbix-release-6.5-1.el8.noarch.rpm > /dev/null 2>&1
dnf clean all > /dev/null 2>&1

echo "Instalando os pacotes necessarios zabbix-proxy-pgsql zabbix-sql-scripts zabbix-selinux-policy"
dnf install -y zabbix-proxy-pgsql zabbix-sql-scripts zabbix-selinux-policy > /dev/null 2>&1

if [ $(rpm -qa | grep postgre | wc -l ) -gt 2 ]; then
    
    clear
    echo "Criando banco..."
    sleep 2   
    echo "Sera necessario inserir a senha!"
    sleep 2
    sudo -u postgres createuser --pwprompt zabbix
    sudo -u postgres createdb -O zabbix zabbix_proxy
    
    echo "Importando tabelas..."
    cat /usr/share/zabbix-sql-scripts/postgresql/proxy.sql | sudo -u zabbix psql zabbix_proxy > /dev/null 2>&1
    
    sed -i 's/DBPassword=password/DBPassword=""/' /etc/zabbix/zabbix_proxy.conf
    
    systemctl enable zabbix-proxy --now
fi
