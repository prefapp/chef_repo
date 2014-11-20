#require_relative 'provider_riyic_app.rb'

class Chef

    class Provider
        
        class WsgiApp < Chef::Provider::RiyicApp

            def install_dependencies
            
                # variables de entorno
                env_hash = {}
            
                if new_resource.requirements_file

                    bash "requirements" do
                      ##########################################################
                      # instalamos como root
                      # para instalar como usuario:
                      # 1) necesitamos que usuario tenha shell e home
                      # 2) necesitamos pasarlle o parametro --user a pip

                      # user        app["owner"]
                      # group       app["group"]
                      #########################################################

                      cwd         new_resource.target_path
                      environment env_hash
                      code        %{pip install -r #{new_resource.requirements_file}}
                    end
                end

                # modulos que non estan no requirements
                Array(new_resource.extra_modules).each do |p|
                  (name,version) = p.split('#')

                  python_pip name do
                    version version if(version)
                  end
                end
            end

            def migrate_db
            end

            def configure_backend
                # configuramos o backend
                uwsgi_python_site new_resource.domain do
                    
                    app_dir       new_resource.target_path
                    entry_point   new_resource.entry_point 
                    socket        new_resource.internal_socket
                    uid           new_resource.owner
                    gid           new_resource.group
                    options       :harakiri => new_resource.timeout
                    threads       new_resource.threads
                    processes     new_resource.processes
                end

            end

            def configure_frontend
                
                # configuramos o frontend
                nginx_uwsgi_site new_resource.domain do
                    server_alias        new_resource.server_alias
                    static_files_path   "#{new_resource.target_path}/#{new_resource.static_files_path}" if new_resource.static_files_path
                    uwsgi_socket        new_resource.internal_socket
                    protocol            'python'
                    uwsgi_read_timeout  new_resource.timeout
                end

            end
        end

    end

end


