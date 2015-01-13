class Chef
    class Resource
        class NginxPassengerSite < Chef::Resource::NginxBaseResource

            self.resource_name = 'nginx_passenger_site'

            attribute :rack_env,
                :kind_of => String,
                :default => 'production'

        end
    end
end
