require 'chef/resource/lwrp_base'

class Chef
    class Resource
        class UwsgiSiteBase < Chef::Resource::LWRPBase

            actions :create, :remove
            
            default_action :create
            
            attribute :name, 
                :kind_of => String, 
                :name_attribute => true

            attribute :app_dir,
                :kind_of => String, 
                :default => nil

            attribute :entry_point, 
                :kind_of => String, 
                :default => 'app.wsgi'

            attribute :uid, 
                :kind_of => String,
                :default => 'uwsgi'
                #:default => node["appserver"]["uwsgi"]["user"]

            attribute :gid, 
                :kind_of => String,
                :default => 'users'
                #:default => node["appserver"]["uwsgi"]["group"]

            attribute :socket, 
                :kind_of => String,
                :default => 'unix:///tmp/uwsgi.sock'
                #:default => node["appserver"]["uwsgi"]["socket"]

            attribute :processes, 
                :kind_of => String,
                :default => 1
                #:default => node["appserver"]["uwsgi"]["processes"]

            attribute :threads, 
                :kind_of => String,
                :default => 0
                #:default => node["appserver"]["uwsgi"]["threads"]

            attribute :options,
                :kind_of => Hash,
                :default => {}

        end
    end
end

#    app = params[:name]
#    app_directory = params[:app_dir]
#    entry_point = params[:entry_point] || 'app.wsgi'
#
#    uid = params[:uid] || node["appserver"]["uwsgi"]["user"]
#    gid = params[:gid] || node["appserver"]["uwsgi"]["group"] 
#    socket = params[:socket] || node["appserver"]["uwsgi"]["socket"]
#    uwsgi_socket = socket.gsub(/^(unix|tcp|udp)?(\:\/\/)?/,'')
