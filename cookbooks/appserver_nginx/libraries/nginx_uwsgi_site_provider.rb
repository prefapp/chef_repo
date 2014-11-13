class Chef
    class Provider
        class NginxUwsgiSite < Chef::Provider::NginxBaseProvider

            def build_vhost
                # parametros do protocolo uwsgi
                # http://uwsgi-docs.readthedocs.org/en/latest/Protocol.html
                uwsgi_modifier1 = 0
                uwsgi_modifier2 = 0
                
                case new_resource.protocol 
                when "perl"
                  uwsgi_modifier1 = 5 
                when "ruby"
                  uwsgi_modifier1 = 7
                when "php"
                  uwsgi_modifier1 = 14
                when "cgi"
                  uwsgi_modifier1 = 9
                when "go"
                  uwsgi_modifier1 = 11
                when "lua"
                  uwsgi_modifier1 = 6
                when "jvm"
                  uwsgi_modifier1 = 8
                when "python"
                  if new_resource.service_location == '/'
                    uwsgi_modifier1 = 0
                  else
                    uwsgi_modifier1 = 30
                  end
                end
                
                template "#{node['nginx']['dir']}/sites-available/#{new_resource.domain}" do
                  source   new_resource.template
                  owner    "root"
                  group    "root"
                  mode     '0644'
                  cookbook new_resource.cookbook
                  variables(
                    :name              => new_resource.domain,
                    :port              => new_resource.port,
                    :uwsgi_socket      => new_resource.uwsgi_socket,
                    :uwsgi_modifier1   => uwsgi_modifier1,
                    :uwsgi_modifier2   => uwsgi_modifier2,
                    :static_files_path => new_resource.static_files_path,
                    :service_location  => new_resource.service_location,
                    :uwsgi_read_timeout => new_resource.uwsgi_read_timeout 
                  )
                end
            end
            
        end
    end
end
