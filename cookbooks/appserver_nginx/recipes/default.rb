## seteamos atributos para o cookbook base (appserver)
node.default["appserver"]["id"] = "nginx_default"
node.default["appserver"]["version"] = node["appserver"]["nginx"]["version"]

## instalamos nginx, ultima version disponible
node.set["nginx"]["version"] = node["appserver"]["nginx"]["version"]
node.set["nginx"]['source']["version"] = node["appserver"]["nginx"]["version"]
node.set['nginx']['source']['checksum'] = node["appserver"]["nginx"]["checksum"]

## seteamos os atributos compostos, de igual forma que se fai no attributes/source.rb de nginx
# para establecer os valores correctos en funcion da version escollida
node.set['nginx']['source']['url']     = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"

node.set['nginx']['source']['prefix'] = "/opt/nginx"
#node.set['nginx']['source']['prefix'] = "/opt/nginx-#{node['nginx']['source']['version']}"
#
node.set['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
node.set['nginx']['source']['default_configure_flags'] = [
  "--prefix=#{node['nginx']['source']['prefix']}",
  "--conf-path=#{node['nginx']['dir']}/nginx.conf"
]

## seteamos os parametros para a receta de nginx da comunidade
node.set["nginx"]["source"]["modules"] = node["appserver"]["nginx"]["modules"]

Chef::Log.info("APPSERVER_ID: #{node['appserver']['id']}")
Chef::Log.info("APPSERVER_VERSION: #{node["appserver"]["version"]}")

require 'pp'
pp node.debug_value(:nginx)

include_recipe "nginx::source"
