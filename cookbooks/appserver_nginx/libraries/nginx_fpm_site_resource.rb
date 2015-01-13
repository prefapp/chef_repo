class Chef
    class Resource
        class NginxFpmSite < Chef::Resource::NginxBaseResource

            self.resource_name = 'nginx_fpm_site'


            attribute :fpm_socket,
                :kind_of => String,
                :default => 'unix:///var/run/php5-fpm.sock'

            attribute :fastcgi_read_timeout,
                :kind_of => String,
                :default => "60"

        end
    end
end
 
