## seteamos atributos para o cookbook base (appserver)
node.set["appserver"]["id"] = "nginx_with_passenger"
node.set["appserver"]["version"] = "3.0.19"

# seteamos os valores para que necesarios para que a receta de passenger
# detecte a instalacion de ruby con rvm
node.set["nginx"]["passenger"]["root"] = "#{node['lang']['ruby']['gemdir']}/gems/passenger-#{node['appserver']['version']}"
node.set["nginx"]["passenger"]["ruby"] = node['lang']['ruby']['wrapper']

node.set["appserver"]["nginx"]["modules"] = 
    node["appserver"]["nginx"]["modules"] | ["passenger"]

###########ESTO PETA!! NON SE DETECTA O CAMBIO DE FLAGS DE COMPILACION¿?!!
## incluimos a receta de passenger
#include_recipe "nginx::passenger"

## usamos gem_dir e ruby_path, 2 helpers definidos no cookbook lang_ruby
#node.set["nginx"]["passenger"]["root"] = "#{gem_dir}/gems/passenger-#{node['appserver']['version']}"
#node.set["nginx"]["passenger"]["ruby"] = ruby_wrapper

Chef::Log.info("NGINX::PASSENGER_ROOT: #{node['nginx']['passenger']['root']} ")
Chef::Log.info("NGINX::PASSENGER_RUBY: #{node["nginx"]["passenger"]["ruby"]}")


# finalmente incluimos a receta default que vai a compilar o nginx cos modulos agregados
include_recipe "appserver_nginx::default"
