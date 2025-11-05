#! /bin/bash

echo "criando diretórios..."



mkdir /publico
mkdir /adm
mkdir /ven
mkdir /sec

echo " Diretórios criados !"


echo " Criando grupo de usuários"

groupadd GRP_ADM
groupadd GRP_VEN
groupadd GRP_SEC
echo " Grupos Criados!"

echo " Criando usuários..."

# 1. Cria o usuário 'carlos' com home e shell /bin/bash
sudo useradd carlos -m -s /bin/bash -G GRP_ADM

# 2. Expira a senha, forçando 'carlos' a definir a própria senha (usando o algoritmo padrão do sistema, que hoje é geralmente SHA-512) no primeiro login.
sudo passwd -e carlos

# 1. Cria o usuário 'maria' com home e shell /bin/bash
sudo useradd maria  -m -s /bin/bash -G GRP_ADM


sudo passwd -e maria

sudo useradd joao -m -s /bin/bash -G GRP_ADM


sudo passwd -e joao

sudo useradd carlos -m -s /bin/bash -G GRP_ADM


sudo passwd -e carlos

sudo useradd debora  -m -s /bin/bash -G GRP_VEN

sudo passwd -e debora

sudo useradd sebastiana  -m -s /bin/bash -G GRP_VEN


sudo passwd -e sebastiana

sudo useradd roberto -m -s /bin/bash -G GRP_VEN


sudo passwd -e roberto


sudo useradd josefina -m -s /bin/bash -G GRP_SEC


sudo passwd -e josefina


sudo useradd amanda -m -s /bin/bash -G GRP_SEC


sudo passwd -e amanda

sudo useradd rogerio -m -s /bin/bash -G GRP_SEC


sudo passwd -e rogerio

echo " Adcionando Usuarios aos grupos ..."

chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec


chmod 770 /adm
chmod 770 /ven
chmod 770 /sec

echo "Finalizando Script de criação de Usuarios , grupos e permissões"
