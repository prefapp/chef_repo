# si temos seteado o flag e senhal de que estamos dentro dun docker
# seteamos daemon_disable para que arranque en primer plano
if node["riyic"]["inside_container"]
    node.override['nginx']['init_style'] = 'init'
    node.override['nginx']['daemon_disable']  = true
end

## seteamos os parametros para a receta de nginx da comunidade
node.set["nginx"]["source"]["modules"] = node["appserver"]["nginx"]["modules"].map{|m| "nginx::#{m}"}

##################################################################################
# dentro dun container de docker usamos runit para facer de vigilante de procesos
# e temos que proporcionar o comando co que runit arrancara o servicio
# - ver o provider Chef::Provider::ContainerService::Runit no cookbook de riyic
##################################################################################
node.set["container_service"]["nginx"]["command"] = "/usr/sbin/nginx -c /etc/nginx/nginx.conf"

# queremos usar o repo de nginx para instalar a ultima version estable
# por paqueteria, sen usar a dos repos de ubuntu
node.set['nginx']['repo_source'] = 'nginx'
node.set['nginx']['install_method'] = 'package'

# 
# creamos o directorio de logs
# ira nun volumen para que sea persistente
#
node.set['nginx']['log_dir'] = "#{Chef::Provider::ContainerService::Runit.logs_base_dir}/nginx"

# desactivamos o limite de client_body_size
# senon por defecto vai a 1Mb
node.set['nginx']['client_max_body_size'] = "0"

include_recipe "nginx::default"


#
# delete conf.d/default.conf
#

nginx_conf_d = "#{node['nginx']['dir']}/conf.d"

nginx_default_conf_file = "#{nginx_conf_d}/default.conf"

file nginx_default_conf_file do

  action :delete
  only_if {
    File.exists?(nginx_default_conf_file)
  }

end

#
# configurar buffer amplio para o proxy
#

file "#{nginx_conf_d}/proxy_buffer.conf" do
  action :create

  content <<EOF

  proxy_buffer_size   128k;
  proxy_buffers   4 256k;
  proxy_busy_buffers_size   256k;

EOF
  
  mode '0644'

end
