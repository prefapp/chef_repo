## seteamos atributos para o cookbook base (appserver)
node.default["appserver"]["id"] = "nginx_default"
node.default["appserver"]["version"] = node["appserver"]["nginx"]["version"]


#
#### ATRIBUTOS PARA A RECETA nginx::source 
#
## instalamos nginx, ultima version disponible
node.set["nginx"]["version"] = node["appserver"]["nginx"]["version"]
node.set["nginx"]['source']["version"] = node["appserver"]["nginx"]["version"]
node.set['nginx']['source']['checksum'] = node["appserver"]["nginx"]["checksum"]

## seteamos os atributos compostos, de igual forma que se fai no attributes/source.rb de nginx
# para establecer os valores correctos en funcion da version escollida
node.set['nginx']['source']['url']     = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"

#node.set['nginx']['source']['prefix'] = "/opt/nginx"
node.set['nginx']['source']['prefix'] = node["appserver"]["nginx"]["install_dir"]
## necesario tamen polo novo atributo sbin_path
node.set['nginx']['source']['sbin_path'] = "#{node['appserver']['nginx']['install_dir']}/sbin/nginx"
#
node.set['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
node.set['nginx']['source']['default_configure_flags'] = [
  "--prefix=#{node['nginx']['source']['prefix']}",
  "--conf-path=#{node['nginx']['dir']}/nginx.conf"
]

## seteamos os parametros para a receta de nginx da comunidade
node.set["nginx"]["source"]["modules"] = node["appserver"]["nginx"]["modules"].map{|m| "nginx::#{m}"}


# novedades para docker, podemolo meter noutro arquivo mellor?

if node["riyic"]["dockerized"] == "yes"
    # o init_style supervisor non existe (de momento), pero utilizara init
    node.override['nginx']['init_style'] = 'supervisor'

    # obligamos a que arranque o nginx en foreground 
    # (a receta nginx::source pono a false por eso o override)
    node.override['nginx']['daemon_disable']  = true
else
    # se non por defecto usar runit e se pelea con chef-init
    node.override['nginx']['init_style'] = 'init'
    node.override['nginx']['daemon_disable']  = true
end


##################################################################################
# dentro dun container de docker usamos runit para facer de vigilante de procesos
# e temos que proporcionar o comando co que runit arrancara o servicio
# - ver o provider Chef::Provider::ContainerService::Runit no cookbook de riyic
##################################################################################
node.set["container_service"]["nginx"]["command"] = "/opt/nginx/sbin/nginx -c /etc/nginx/nginx.conf"


include_recipe "nginx::source"

# si queremos usar o supervisor vamos a usar o provider que nos da o seu cookbook
# pero temos que deshabilitar o nginx para que sexa supervisor quen o xestione
if node["riyic"]["dockerized"] == "yes"

    # deshabilitamos o servicio nginx para que non se arranque automaticamente
    # queremos controlalo con supervisor
    srv = resources(service: "nginx")
    # srv.provider Chef::Provider::Service::Upstart
    srv.start_command "/bin/true"
    srv.stop_command "/bin/true"
    srv.restart_command "/bin/true"
    srv.action :nothing

    include_recipe "pcs_supervisor::default"

    supervisor_service "nginx" do        
        stdout_logfile "/var/log/supervisor/nginx.log"
        stderr_logfile "/var/log/supervisor/nginx.err"
        command node["nginx"]["binary"]
        action "enable"
    end
end
