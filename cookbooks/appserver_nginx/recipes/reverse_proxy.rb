# por defecto nginx xa se compila con soporte para http-proxy
# http://nginx.org/en/docs/configure.html

# incluimos a receta default que vai a compilar o nginx cos modulos agregados
#include_recipe "appserver_nginx::default"
include_recipe "appserver_nginx::package"


# agregamos a configuracion a seccion http, recomendada para soportar websocket 
# si o cliente o solicita (http://nginx.org/en/docs/http/websocket.html)
template "ws.conf" do
  path "#{node['nginx']['dir']}/conf.d/ws.conf"
  source "ws.conf.erb"
  owner "root"
  group "root"
  mode 00644
end

## We need generate a stronger DHE parameter
# https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
DHE_PARAM_FILE='/etc/ssl/dhparam.pem'

execute 'DHE param' do
  command 'openssl dhparam -dsaparam -out /etc/ssl/dhparam.pem 4096'
  creates DHE_PARAM_FILE
  not_if {
    File.exists?(DHE_PARAM_FILE) &&
    File.mtime(DHE_PARAM_FILE) < Time.now - 5000000 #60dias
  }
end

# creamos os sites, cos backends (upstream servers) que se especifiquen
# e con soporte ssl se se pide (os certificados e a key estar en ficheiros con nome do dominio)
node['appserver']['nginx']['reverse_proxy_sites'].each do |site|
 
  #creamos a plantilla do host 
  template site['domain'] do
    path "#{node['nginx']['dir']}/sites-available/#{site['domain']}"
    source "reverse_proxy.erb"
    owner "root"
    group "root"
    mode 00644

    variables(
      :domain => site['domain'],
      :public_port => site['public_port'] || 80,
      :service_path => site['service_path'] || '/',
      :backends => site["backends"],
      :ssl => (site["ssl"] == 'yes')? true : false,
      :letsencrypt => (site['letsencrypt'] == 'yes')? true : false,
      :redirect_to_https => (site['redirect_to_https'] == 'yes')? true : false,
      :dhe_param_file => DHE_PARAM_FILE,
    )

  end

  ##habilitamos o site
  nginx_site site['domain']

end

n = resources("service[nginx]")
n.restart_command('/bin/true')



