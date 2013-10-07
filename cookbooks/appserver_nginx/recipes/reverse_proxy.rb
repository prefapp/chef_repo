# por defecto nginx xa se compila con soporte para http-proxy
# http://nginx.org/en/docs/configure.html

# finalmente incluimos a receta default que vai a compilar o nginx cos modulos agregados
include_recipe "appserver_nginx::default"

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
            :ssl => site["ssl"] || false
        )

        #not_if { File.exists?("#{node['nginx']['dir']}/sites-available/#{site['domain']}") }
    end

    ##habilitamos o site
    nginx_site site['domain']

end



