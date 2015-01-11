# seteamos a version de nginx a instalar
node.set["nginx"]["passenger"]["version"] = node["appserver"]["nginx"]["passenger"]["version"]

# seteamos os valores necesarios para que a receta de passenger
# detecte a instalacion de ruby con rvm
node.set["nginx"]["passenger"]["root"] = "#{node['lang']['ruby']['gemdir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
node.set["nginx"]["passenger"]["ruby"] = node['lang']['ruby']['wrapper']

## usamos gem_dir e ruby_path, 2 helpers definidos no cookbook lang_ruby
#node.set["nginx"]["passenger"]["root"] = "#{gem_dir}/gems/passenger-#{node['appserver']['version']}"
#node.set["nginx"]["passenger"]["ruby"] = ruby_wrapper

Chef::Log.info("NGINX::PASSENGER_ROOT: #{node['nginx']['passenger']['root']} ")
Chef::Log.info("NGINX::PASSENGER_RUBY: #{node["nginx"]["passenger"]["ruby"]}")


# agregamos a instalacion do modulo passenger
node.set["appserver"]["nginx"]["modules"] = 
    node["appserver"]["nginx"]["modules"] | ["passenger"]


# finalmente incluimos a receta default que vai a compilar o nginx cos modulos agregados
include_recipe "appserver_nginx::default"
