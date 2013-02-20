## seteamos atributos para o cookbook base (appserver)
node.set["appserver"]["id"] = "nginx_with_passenger"
node.set["appserver"]["version"] = "3.0.19"

## instalamos nginx, ultima version disponible
node.set["nginx"]["version"] = node["appserver"]["nginx"]["version"]
node.set['nginx']['source']['checksum'] = node["appserver"]["nginx"]["checksum"]

## seteamos os parametros para a receta de nginx da comunidade
node.set["nginx"]["source"]["modules"] = node["appserver"]["nginx"]["modules"]


node.set["nginx"]["passenger"]["root"] = "#{node['lang']['ruby']['gemdir']}/gems/passenger-#{node['appserver']['version']}"
node.set["nginx"]["passenger"]["ruby"] = node['lang']['ruby']['wrapper']

## usamos gem_dir e ruby_path, 2 helpers definidos no cookbook lang_ruby
#node.set["nginx"]["passenger"]["root"] = "#{gem_dir}/gems/passenger-#{node['appserver']['version']}"
#node.set["nginx"]["passenger"]["ruby"] = ruby_wrapper

Chef::Log.info("NGINX::PASSENGER_ROOT: #{node['nginx']['passenger']['root']} ")
Chef::Log.info("NGINX::PASSENGER_RUBY: #{node["nginx"]["passenger"]["ruby"]}")
include_recipe "nginx::source"
