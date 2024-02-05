# Copyright (C) 2024 Alcides Goldoni Junior <goldoni@versatushpc.com.br>
#!/bin/bash

echo "Instalacao do Zabbix Proxy para familia RHEL 8"

echo "Sera necessario parar o servico"
systemctl stop zabbix-agent zabbix-proxy

echo "Removendo pacotes antigos"
dnf remove zabbix-release

echo "Removendo banco de dado antigos"
rm -f /var/lib/zabbix/zabbix_proxy.db

echo "Instalando repo..."
rpm -Uvh https://repo.zabbix.com/zabbix/6.5/rhel/8/x86_64/zabbix-release-6.5-1.el8.noarch.rpm > /dev/null 2>&1
dnf clean all > /dev/null 2>&1

echo "Instalando os pacotes necessarios zabbix-proxy-sqlite3 zabbix-selinux-policy zabbix-sql-scripts zabbix-agent"
dnf install -y zabbix-proxy-sqlite3 zabbix-selinux-policy zabbix-sql-scripts zabbix-agent  > /dev/null 2>&1

echo "Configutando banco dedados"
cat /usr/share/zabbix-sql-scripts/sqlite3/proxy.sql | sqlite3 /var/lib/zabbix/zabbix_proxy.db
chown zabbix:zabbix /var/lib/zabbix/zabbix_proxy.db

echo "Salvando arquivo de configuracao original"
cp  /etc/zabbix/zabbix_proxy.conf  /etc/zabbix/zabbix_proxy.conf_save

echo "Configurando zabbix_proxy.conf"
sed 's/DBHost/DBHost=localhost' /etc/zabbix/zabbix_proxy.conf
sed 's/DBUser/DBUser=zabbix' /etc/zabbix/zabbix_proxy.conf
sed 's/DBPassword/DBPassword=' /etc/zabbix/zabbix_proxy.conf

echo "criando as politicas do SElinux"
cat << EOF > zabbix_policy.te
module zabbix_policy 1.2;
require {
  type zabbix_t;
  type zabbix_port_t;
  type zabbix_var_run_t;
  class tcp_socket name_connect;
  class sock_file { create unlink };
  class unix_stream_socket connectto;
}
#============= zabbix_t ==============
allow zabbix_t self:unix_stream_socket connectto;
allow zabbix_t zabbix_port_t:tcp_socket name_connect;
allow zabbix_t zabbix_var_run_t:sock_file create;
allow zabbix_t zabbix_var_run_t:sock_file unlink;
EOF
checkmodule -M -m -o zabbix_policy.mod zabbix_policy.te
semodule_package -o zabbix_policy.pp -m zabbix_policy.mod
semodule -i zabbix_policy.pp


echo "Sera necessario parar o servico"
systemctl enable  zabbix-agent zabbix-proxy
systemctl restart zabbix-agent zabbix-proxy

