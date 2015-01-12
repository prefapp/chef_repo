require 'chef/provider/lwrp_base'

class Chef
     class Provider
          class UwsgiBaseProvider < Chef::Provider::LWRPBase
              use_inline_resources if defined?(:use_inline_resources)

              action :create do
                  run_options = base_run_options

                  run_options.merge!(specific_plugin_options)

                  configure_service(run_options)

               end

               private 

                def base_run_options 
                    uwsgi_socket = new_resource.socket.gsub(/^(unix|tcp|udp)?(\:\/\/)?/,'')
                    run_options = {}
                    run_options["socket"] = uwsgi_socket
                    run_options["plugins-dir"] = node["appserver"]["uwsgi"]["installation_path"]

                    run_options["processes"] = new_resource.processes if new_resource.processes > 0
                    run_options["threads"] = new_resource.threads if new_resource.threads > 0

                    run_options["chdir"] = new_resource.app_dir

                    run_options["master"] = ""
                    
                    # necesario para que runit consiga parar el servicio 
                    # (invierte el comportamiento de uwsgi con SIGKILL y SIGTERM)
                    run_options["die-on-term"] = ""

                    # run_options["daemonize"] = params[:log_file]

                    run_options["uid"] = new_resource.uid
                    run_options["gid"] = new_resource.gid

                    run_options["chmod-socket"] = "666"
                    run_options["need-app"] = ""
                    run_options["vacuum"] = ""

                    run_options.merge!(new_resource.options)
                end


                def configure_service(run_options)

                    # construimos o comando que lance o uwsgi (tamen se poderia facer un ficheiro ini)
                    command = "/usr/local/bin/uwsgi"

                    run_options.each do |k,v|
                      command << " --#{k}"
                      command << "=#{v}" unless v==""
                    end

                    Chef::Log.info("Compilation command: #{command}")

                    # comando para runit (dentro dun docker container)
                    node.set["container_service"]["uwsgi"]["command"] = command

                    service "uwsgi" do
                        action [:enable, :start]
                    end

                end
          end
     end
end
