include_recipe "lang_ruby::install"

# seteamos a version de nginx a instalar
node.set["nginx"]["passenger"]["version"] = node["appserver"]["nginx"]["passenger"]["version"]

# seteamos os valores necesarios para que a receta de passenger
# detecte a instalacion de ruby con rvm
# ou o ruby instalado desde o repo de brightbox
if node['lang']['ruby']['use_rvm']
    node.set["nginx"]["passenger"]["ruby"] = node['lang']['ruby']['wrapper']
else
    node.set["nginx"]["passenger"]["ruby"] = node["lang"]["ruby"]["binary_path"] 
end

node.set["nginx"]["passenger"]["root"] = "#{node['lang']['ruby']['gemdir']}/gems/passenger-#{node['nginx']['passenger']['version']}"


Chef::Log.info("NGINX::PASSENGER_ROOT: #{node['nginx']['passenger']['root']} ")
Chef::Log.info("NGINX::PASSENGER_RUBY: #{node["nginx"]["passenger"]["ruby"]}")


# agregamos a instalacion do modulo passenger
node.set["appserver"]["nginx"]["modules"] = 
    node["appserver"]["nginx"]["modules"] | ["passenger"]

# forzamos a que se compile o passenger (por defecto no cookbook de nginx usa paqueteria)
node.set['nginx']['passenger']['install_method'] = 'source'


# finalmente incluimos a receta default que vai a compilar o nginx cos modulos agregados
include_recipe "appserver_nginx::default"
