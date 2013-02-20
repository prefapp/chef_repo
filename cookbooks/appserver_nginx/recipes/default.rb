## seteamos atributos para o cookbook base (appserver)
node.set["appserver"]["id"] = "nginx_default"
node.set["appserver"]["version"] = "1.2.6"

## instalamos nginx, ultima version disponible
node.set["nginx"]["version"] = node["appserver"]["nginx"]["version"]
node.set['nginx']['source']['checksum'] = node["appserver"]["nginx"]["checksum"]

include_recipe "nginx::source"
