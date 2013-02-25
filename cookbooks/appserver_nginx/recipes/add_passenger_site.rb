DEFAULT_ENV = 'production'

include_recipe "appserver_nginx::with_passenger"


node['lang']['ruby']['rails']['sites'].each do |site|
    
    #creamos a plantilla do vhost
    template site['domain'] do
        path "#{node['nginx']['dir']}/sites-available/#{site['domain']}"
        source "passenger-site.erb"
        owner "root"
        group "root"
        mode 00644

        if site.has_key?("rails_env")
            rails_env = site["rails_env"]
        else
            rails_env = DEFAULT_ENV
        end

        variables(
            :domain => site['domain'],
            :document_root => "#{site['document_root']}/public",
            :rails_env => rails_env
        )

        #not_if { File.exists?("#{node['nginx']['dir']}/sites-available/#{site['domain']}") }
    end

    ##habilitamos o site
    nginx_site site['domain']

end

