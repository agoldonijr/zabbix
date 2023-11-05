#!/bin/bash

echo "Istalacao do Zabbix Agent 2 para familia RHEL 8"
sleep 4

if [ -f /etc/yum.repos.d/epel.repo ]; then
        echo "excludepkgs=zabbix*" >>  /etc/yum.repos.d/epel.repo
fi

echo "Adicionando repositório"
rpm -Uvh https://repo.zabbix.com/zabbix/6.5/oracle/9/x86_64/zabbix-release-6.5-2.el9.noarch.rpm > /dev/null 2>&1
dnf clean all > /dev/null 2>&1
echo "Instalando pacotes zabbix-agent2 zabbix-agent2-plugin-postgresql "
dnf install -y zabbix-agent2 zabbix-agent2-plugin-postgresql > /dev/null 2>&1 

systemctl enable zabbix-agent2 --now
systemctl status zabbix-aget2

if [ -f /etc/zabbix/zabbix_agentd.conf ]; then

    ARQ=/etc/zabbix/zabbix_agentd.conf

elif [ -f /etc/zabbix/zabbix_agent2.conf ]; then
    
    ARQ=/etc/zabbix/zabbix_agent2.conf

else

    echo "Arquivo de configuracao nao encontrado"
    exit 1

fi 

read -p "IP do servidor : " SERVER

echo "Configurando arquivo $ARQ com o ip $SERVER" ...
sleep 1	

sed -i "s/Server=127.0.0.1/Server=$SERVER/g" $ARQ 
sed -i "s/ServerActive=127.0.0.1/ServerActive=$SERVER/g" $ARQ
sed -i "s/HostnameItem=system.hostname/HostnameItem=system.run[\/usr\/bin\/hostname -a]/g" $ARQ
echo "Verifique se o arquivo foi configurado corretamente e reinicie o serviço"
echo "systemctl restart zabbix-agent2"
sleep 1
