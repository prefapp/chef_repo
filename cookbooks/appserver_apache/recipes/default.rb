server = node["appserver"]["apache"]
#
###seteamos os atributos da receta de apache2, a partir dos nosos
node.set["apache"]["listen_ports"] = server["listen_ports"]
node.set["apache"]["timeout"] = server["timeout"]
node.set["apache"]["default_modules"] = server["default_modules"]
node.set["apache"]["mpm"] = server["mpm"]


# seteamos os atributos para o cookbook de apache, a partir dos nosos atributos
#node.set["apache"] = node["appserver"]["apache"]

server_root = node["appserver"]["apache"]["conf_dir"]

#node.set["container_service"]["apache2"]["command"] = 
#  "/usr/sbin/apache2 -D FOREGROUND -f #{server_root}/apache2.conf"

# como non vamos a utilizar apachectl
# porque non mata o apache cando runit lle manda a signal de stop
# temos que realizar as suas labores de preparacion aqui

# 
# o script de arranque ten que cargar as variables de configuracion
#
node.set['container_service']['apache2']['run_script_content'] = <<EOF
#!/bin/bash
exec 2>&1
source /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND -f /etc/apache2/apache2.conf 2>&1
EOF


# crear o directorio donde vai o pid e o mutex
# (/var/run/apache2)
directory node['apache']['run_dir'] 

# crear o directorio do lock
# este ten que ser baixo o usuario que vai a correr o apache
directory node['apache']['lock_dir'] do
  owner node['apache']['user']
  group node['apache']['group']
end


include_recipe "apache2"
