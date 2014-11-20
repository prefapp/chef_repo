class Chef
    class Provider
        class NginxPassengerSite < Chef::Provider::NginxBaseProvider

            def build_vhost                

                template "#{node['nginx']['dir']}/sites-available/#{new_resource.domain}" do

                  source   new_resource.template || 'passenger_site.erb'

                  owner    "root"
                  group    "root"
                  mode     '0644'
                  cookbook new_resource.cookbook

                  variables(
                    :name                   => new_resource.domain,
                    :alternate_names        => new_resource.server_alias,
                    :port                   => new_resource.port,
                    :static_files_path      => new_resource.static_files_path,
                    :service_location       => new_resource.service_location,
                    :passenger_app_env      => new_resource.rack_env,
                  )
                end

            end
        end
    end
end