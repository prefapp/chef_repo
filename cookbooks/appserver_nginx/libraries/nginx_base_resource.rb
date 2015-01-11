require 'chef/resource/lwrp_base'

class Chef
    class Resource
        class NginxBaseResource < Chef::Resource::LWRPBase

            actions :create, :remove
            
            default_action :create
            
            attribute :domain, 
                :kind_of => String, 
                :name_attribute => true

            attribute :server_alias, 
                :kind_of => [Array, NilClass], 
                :default => nil

            attribute :document_root,
                :kind_of => String,
                :default => ''

            attribute :template,
                :kind_of => [String,NilClass],
                :default => nil

            attribute :cookbook,
                :kind_of => String,
                :default => 'appserver_nginx'

            attribute :port,
                :kind_of => Integer,
                :default => 80

            attribute :service_location,
                :kind_of => String,
                :default => '/'

            attribute :static_files_path,
                :kind_of => [String, NilClass],
                :default => nil

        end
    end

end
