## seteamos atributos para o cookbook base (appserver)
node.default["appserver"]["id"] = "nginx_default"
node.default["appserver"]["version"] = node["appserver"]["nginx"]["version"]

## instalamos nginx, ultima version disponible
node.set["nginx"]["version"] = node["appserver"]["nginx"]["version"]
#node.set['nginx']['source']['url'] = "http://nginx.org/download/nginx-1.2.7.tar.gz"
node.set['nginx']['source']['checksum'] = node["appserver"]["nginx"]["checksum"]

## seteamos os parametros para a receta de nginx da comunidade
node.set["nginx"]["source"]["modules"] = node["appserver"]["nginx"]["modules"]

Chef::Log.info("APPSERVER_ID: #{node['appserver']['id']}")
Chef::Log.info("APPSERVER_VERSION: #{node["appserver"]["version"]}")
Chef::Log.info("nginx_VERSION: #{node["appserver"]["nginx"]["version"]}")

include_recipe "nginx::source"
