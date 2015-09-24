include_recipe "app_redmine::default"

app = node["app"]["redmine"]

package "imagemagick"
package "libmagickwand-dev"

rack_app app["domain"] do

    target_path        app['target_path']
    action             :deploy
    owner              app['user']
    group              app['group']
    timeout            "600"

    repo_url           app["repo_url"]
    repo_type          app["repo_type"]
    revision           app["revision"]
    purge_target_path  'yes'

    migration_command  'bundle exec rake db:migrate'

    notifies          :restart, 'service[nginx]'

end

# generate config file
template "#{app['target_path']}/config/database.yml" do

    source      'database.yml.erb'
    cookbook    "app_redmine"
    user        app["user"]
    group       app["group"]
    variables   ({
        :app => app,
    })

end

# generate secret token (postdeploy tasks)
#bash 'generate_secret_token_redmine' do
#   user		    app['user']
#   group        app["group"]
#   cwd 		    app['target_path']
#   code         'bundle exec rake generate_secret_token'
#end

# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
    
    file "#{node['riyic']['extra_tasks_dir']}/redmine-#{app['domain']}.sh" do

        mode '0700'
        owner 'root'
        group 'root'

        content <<-EOF

su -c 'cd #{app['target_path']} && bundle exec rake generate_secret_token' #{app['user']}
        
EOF
    
    end    

else
    bash 'generate_secret_token_redmine' do
       user		    app['user']
       group        app["group"]
       cwd 		    app['target_path']
       code         'bundle exec rake generate_secret_token'
    end

end
