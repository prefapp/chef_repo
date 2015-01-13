require_relative "uwsgi_base_resource.rb"

class Chef
    class Resource
        class UwsgiPythonSite < Chef::Resource::UwsgiSiteBase
            self.resource_name = 'uwsgi_python_site'
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
