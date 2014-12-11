include_recipe "app_php::default"

node["app"]["php"]["fcgi_apps"].each do |app|

	fcgi_app app["domain"] do 

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
                        timeout
                        extra_modules
                        extra_packages

                        purge_target_path
                        repo_depth


                ).each do |m|

                        v = app[m] || node["app"]["php"]["default_#{m}"]

                        self.send(m,v)

                end

                notifies   :restart, 'service[nginx]'

	end
end
