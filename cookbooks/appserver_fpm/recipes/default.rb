##################################################################################
# dentro dun container de docker usamos runit para facer de vigilante de procesos
# e temos que proporcionar o comando co que runit arrancara o servicio
# - ver o provider Chef::Provider::ContainerService::Runit no cookbook de riyic
##################################################################################
node.set["container_service"]["php5-fpm"]["command"] = "/usr/sbin/php5-fpm -F --fpm-config /etc/php5/fpm/php-fpm.conf"


#
# deixamos que o noso cookbook base se encarge de actualizar a cache do apt
#
#node.set["php_fpm"]["update_system"] = false
node.set["php_fpm"]["run_update"] = false

# install common php modules (curl, php5-mysql ...)
node.set["php_fpm"]["install_php_modules"] = false

# que non se cree o pool por defecto (www)
node.set['php_fpm']['pools'] = []

include_recipe "php5-fpm::install"

