class Chef
    class Provider
        class PsgiApp < Chef::Provider::RiyicApp

            def install_dependencies

                if new_resource.extra_modules

                    Array(new_resource.extra_modules).each do |m|

                        # como non temos a definition perlenv_shell
                        if node['lang']['perl']['version'] == 'system'

                            bash 'install_extra_modules' do
                                code    "cpanm #{m} --notest"
                            end
                        else
                            perlbrew_cpanm 'install_extra_modules' do
                                perlbrew    node["lang"]["perl"]["version"]
                                modules     [m]
                                options     "--notest"
                            end

                        end
                    end
                end

            end


            def migrate_db
                return unless new_resource.migration_command

                # como non temos a definition perlenv_shell
                if node['lang']['perl']['version'] == 'system'

                    super

                else
                    perlbrew_run "migration_#{new_resource.domain}" do
                        perlbrew    perlbrew node["lang"]["perl"]["version"]
                        user        new_resource.owner
                        group       new_resource.group
                        cwd         new_resource.target_path
                        environment env_hash
                        command     new_resource.migration_command
                    end
                end
                
            end

            def run_postdeploy_script
                return unless new_resource.postdeploy_script

                if node['lang']['perl']['version'] == 'system'
                    
                    super

                else
                    perlbrew_run "postdeploy_script.#{new_resource.postdeploy_script}" do 
                        perlbrew        perlbrew node["lang"]["perl"]["version"]
                        user            new_resource.owner
                        group           new_resource.group
                        cwd             new_resource.target_path
                        environment     env_hash
                        command         %{bash #{new_resource.target_path}/#{new_resource.postdeploy_script}}

                        only_if {
                                !node["riyic"]["inside_container"] &&
                                ::File.exists?("#{new_resource.target_path}/#{new_resource.postdeploy_script}")
                        }

                    end

                end

            end

            def configure_backend
                # configuramos o backend
                uwsgi_psgi_site new_resource.domain do
                    
                    app_dir       new_resource.target_path
                    entry_point   new_resource.entry_point 
                    socket        new_resource.internal_socket
                    uid           new_resource.owner
                    gid           new_resource.group
                    options       :harakiri => new_resource.timeout
                    threads       new_resource.threads
                    processes     new_resource.processes
                    coroae        new_resource.coroae
                end

            end

            def configure_frontend
                
                # configuramos o frontend
                nginx_uwsgi_site new_resource.domain do
                    server_alias        new_resource.server_alias
                    document_root       new_resource.target_path
                    static_files_path   "#{new_resource.target_path}/#{new_resource.static_files_path}" if new_resource.static_files_path
                    uwsgi_socket        new_resource.internal_socket
                    protocol            'perl'
                    uwsgi_read_timeout  new_resource.timeout
                end

            end

        end
    end
end
