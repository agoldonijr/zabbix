#!/bin/bash

echo "Instalacao do PostgreSQL 15"
sleep 2

echo "Update de sistema..."
dnf update -y > /dev/null 2>&1

echo "Instalando repo..."
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm > /dev/null 2>&1
dnf -qy module disable postgresql > /dev/null 2>&1
echo "Instalando postgresql15-server "
dnf install -y postgresql15-server > /dev/null 2>&1

echo "Iniciando o bancoa de dados..."
/usr/pgsql-15/bin/postgresql-15-setup initdb

echo "Iniciando o servico..."
systemctl enable postgresql-15 --now
systemctl status postgresql-15
