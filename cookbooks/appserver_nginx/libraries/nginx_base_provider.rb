require 'chef/provider/lwrp_base'

class Chef
    class Provider
        class NginxBaseProvider < Chef::Provider::LWRPBase
            use_inline_resources if defined?(:use_inline_resources)

            action :create do
                build_vhost
                enable_site
            end

            protected

            def enable_site

                execute "nxensite #{new_resource.domain}" do
                    command "#{node['nginx']['script_dir']}/nxensite #{new_resource.domain}"
                    
                    not_if do
                        ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{new_resource.domain}") ||
                        ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/000-#{new_resource.domain}")
                    end
                end
            end
        end
    end
end

