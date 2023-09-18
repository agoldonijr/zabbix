#!/bin/bash

#Funcao para remover os pacotes do zabbix
remove(){
    rpm -qa | grep zabbix | xargs -I{} dnf -y remove {} > /dev/null 2>&1 

    #Validando se existem pacotes do zabbix
    if [ $(rpm -qa | grep zabbix | wc -l) -eq 0 ]; then
        echo "Pacotes removidos!"
    else
        echo "Algo deu errado! Verifique manualmente se existem pacotes do Zabbix instalados!"
    fi
}



clear
echo "Cuidado!"
sleep 2
echo "Esse script (teoricamente) remove todos os pacotes relacionados ao Zabbix"
sleep 2
echo "Caso seus sistema esteja corrompido, existem a possibidade de quebrar o sistema!"

while true; do
    read -p  "Deseja continuar? [S/N]" response
    case "$response" in
        
        [Ss])
            echo "Removendo os pacotes... Isso pode demorar alguns minutos"
            remove 
            break
            ;;

        [Nn])
            echo "Saindo..."
            exit 1
            break
            ;;
        *)
            echo "Opcao invalida!"
            ;;
    esac
done


