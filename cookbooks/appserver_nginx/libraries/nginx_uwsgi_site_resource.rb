class Chef
    class Resource
        class NginxUwsgiSite < Chef::Resource::NginxBaseResource

            self.resource_name = 'nginx_uwsgi_site'

            attribute :protocol,
                :equal_to => %w{perl python ruby php cgi go lua jvm},
                :default => 'python'

            attribute :uwsgi_socket,
                :kind_of => String,
                :default => 'unix:///tmp/uwsgi.sock'

            attribute :uwsgi_read_timeout,
                :kind_of => String,
                :default => "60"

        end
    end
end
