#/bin/bash

# script para empaquetar os cookbooks
# primeiro creamos o paquete cos cookbooks da comunidade
# e despois agregamos os nosos


#CHEF_REPO_OPSCODE=~/proxectos/chef/opscode
#CHEF_REPO_OPSCODE=~/proxectos/chef/cookbooks/supermarket/
CHEF_REPO_BASE=./vendor_cookbooks
CHEF_REPO_RIYIC=./cookbooks

WEBAPP_PROD_PATH=/home/rails/riyic
#WEBAPP_PROD_PATH=/home/riyic/app
WEBAPP_DEV_PATH=~/proxectos/riyic
LXC_SHARED=~/proxectos/lxc/shared

DESTINATION=$1

rm -f /tmp/cookbooks.tar*
rm -rf /tmp/cookbooks && mkdir /tmp/cookbooks

cp -a $CHEF_REPO_BASE/* /tmp/cookbooks
#cp -a $CHEF_REPO_OPSCODE/* /tmp/cookbooks
cp -a $CHEF_REPO_RIYIC/* /tmp/cookbooks

tar -cpf  /tmp/cookbooks.tar --exclude ".git"  --exclude ".kitchen" --exclude "update.pl" --exclude "off_*" -C /tmp/ cookbooks

# cd $CHEF_REPO_BASE && tar -cvpf /tmp/cookbooks.tar --exclude ".*" --exclude "off_*" *
# cd $CHEF_REPO_OPSCODE && tar -rvpf /tmp/cookbooks.tar --exclude ".*" --exclude "off_*" *
# cd $CHEF_REPO_RIYIC && tar -rvpf /tmp/cookbooks.tar --exclude ".*" --exclude "off_*" *

gzip /tmp/cookbooks.tar
echo "Creado paquete de cookbooks en '/tmp/cookbooks.tar.gz'"

#copiamolos a local
# if [ -d "$WEBAPP_DEV_PATH" ];then
#     echo "copiando cookbooks.tar.gz a $WEBAPP_DEV_PATH/public/"
#     cp /tmp/cookbooks.tar.gz $WEBAPP_DEV_PATH/public/
# fi

# #copiamolos a carpeta compartida de lxc
# if [ -d "$LXC_SHARED" ];then
#     echo "copiando cookbooks.tar.gz a $LXC_SHARED/"
#     cp -a /tmp/cookbooks.tar.gz $LXC_SHARED/
# fi

if ! [[ -z $DESTINATION ]]; then

    echo "Enviando /tmp/cookbooks.tar.gz A http://riyic.s3.amazonaws.com/cookbooks.tar.gz"
    s3cmd put /tmp/cookbooks.tar.gz s3://riyic/ -P

fi
