require_relative "uwsgi_base_provider.rb"

class Chef
     class Provider
          class UwsgiPythonSite < Chef::Provider::UwsgiBaseProvider

               def specific_plugin_options
                    {
                        "plugin" => "python",
                        "wsgi-file" => @new_resource.entry_point
                    }
               end

          end
          
     end
end
