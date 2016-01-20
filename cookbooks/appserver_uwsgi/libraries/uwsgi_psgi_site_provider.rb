require_relative "uwsgi_base_provider.rb"

class Chef
     class Provider
          class UwsgiPsgiSite < Chef::Provider::UwsgiBaseProvider

               def specific_plugin_options
                    options = {
                        "plugin" => "psgi",
                        "perl-no-die-catch" => '',
                        "psgi" => new_resource.entry_point,
                    }

                    # si queremos usar coroae hai configurar outro plugin
                    if new_resource.coroae > 0 
                        options["plugin"] << ',coroae'
                        options["coroae"] = new_resource.coroae
                    end

                    options

               end

          end
          
     end
end
