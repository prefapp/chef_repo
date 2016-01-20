class Chef
    class Provider
        class NginxFpmSite < Chef::Provider::NginxBaseProvider

            def build_vhost                

                template "#{node['nginx']['dir']}/sites-available/#{new_resource.domain}" do

                  source   new_resource.template || 'fpm_site.erb'

                  owner    "root"
                  group    "root"
                  mode     '0644'
                  cookbook new_resource.cookbook

                  variables(
                    :name                   => new_resource.domain,
                    :alternate_names        => new_resource.server_alias,
                    :document_root          => new_resource.document_root,
                    :port                   => new_resource.port,
                    :fpm_socket             => new_resource.fpm_socket,

                    :static_files_path      => new_resource.static_files_path,
                    :service_location       => new_resource.service_location,
                    :fastcgi_timeout        => new_resource.fastcgi_read_timeout
                  )
                end

            end
        end
    end
end
