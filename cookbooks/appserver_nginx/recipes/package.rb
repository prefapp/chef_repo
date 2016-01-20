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

include_recipe "nginx::default"
