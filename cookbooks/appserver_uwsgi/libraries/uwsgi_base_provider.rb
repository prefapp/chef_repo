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
                    #run_options["plugin"] = "python"
                    #run_options["wsgi-file"] = new_resource.entry_point

                    run_options["processes"] = new_resource.processes if new_resource.processes > 0
                    run_options["threads"] = new_resource.threads if new_resource.threads > 0

                    run_options["chdir"] = new_resource.app_dir

                    run_options["master"] = ""
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

                    # instalamos o supervisord e configuramos o control do uwsgi

                    supervisor_service new_resource.name do        
                        stdout_logfile "/var/log/supervisor/#{new_resource.name}.log"
                        stderr_logfile "/var/log/supervisor/#{new_resource.name}.err"
                        command command
                        startsecs 10
                        stopsignal "QUIT"
                        stopasgroup true
                        killasgroup true
                        action [:enable,:start]
                    end

                end
          end
     end
end
