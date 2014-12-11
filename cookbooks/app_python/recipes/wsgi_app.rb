include_recipe "app_python::default"

# Seria para usar de forma apilable, para poder facer o deploy de varias apps
node["app"]["python"]["wsgi_apps"].each do |app|

	wsgi_app app["domain"] do 

                %W(
                        server_alias 
                        target_path
                        entry_point
                        owner
                        group

                        repo_url
                        repo_type
                        revision
                        credential

                        environment

                        static_files_path
 
                        migration_command
                        postdeploy_script

                        timeout
                        extra_modules
                        extra_packages
                        requirements_file

                        purge_target_path
                        repo_depth


                ).each do |m|

                        v = app[m] || node["app"]["wsgi"]["default_#{m}"]

                        self.send(m,v)

                end

                notifies   :restart, 'service[nginx]'

	end
end
