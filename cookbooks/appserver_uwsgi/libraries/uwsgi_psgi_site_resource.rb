require_relative "uwsgi_base_resource.rb"

class Chef
    class Resource
        class UwsgiPythonSite < Chef::Resource::UwsgiSiteBase
            self.resource_name = 'uwsgi_psgi_site'

            attribute :coroae, 
                :kind_of => Integer,
                :default => 0
        end
    end
end