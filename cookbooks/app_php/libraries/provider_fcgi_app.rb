#require_relative 'provider_riyic_app.rb'

class Chef

    class Provider

        class FcgiApp < Chef::Provider::RiyicApp

            def install_dependencies

                # modulos que non estan no requirements
                Array(new_resource.extra_modules).each do |p|
                    (name,version) = p.split('#')

                    php_pear name do
                        version version if(version)
                        action :install
                    end
                end
            end


            def configure_backend

                php5_fpm_pool new_resource.domain do

                    # php5_fpm_pool actualmente solo soporta tcp/ip sockets
                    listen_address              '127.0.0.1'
                    listen_port                 9000
                    php_ini_values              "max_execution_time" => new_resource.timeout
                    request_terminate_timeout   new_resource.timeout.to_i
                    overwrite                   true

                end

                new_resource.internal_socket('127.0.0.1:9000')

            end


            def configure_frontend

                # configuramos o frontend
                nginx_fpm_site new_resource.domain do

                    server_alias            new_resource.server_alias
                    document_root           new_resource.target_path

                    static_files_path       "#{new_resource.target_path}/#{new_resource.static_files_path}" if new_resource.static_files_path
                    fpm_socket              new_resource.internal_socket
                    fastcgi_read_timeout    new_resource.timeout

                end

            end
        end

    end

end
