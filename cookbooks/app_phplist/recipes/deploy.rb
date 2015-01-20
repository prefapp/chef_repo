include_recipe "app_phplist::default"

node["app"]["phplist"]["installations"].each do |app|

    owner = app["user"] || node["app"]["phplist"]["default_user"]
    group = app["group"] || 'users'

    # instalamos a aplicacion e configuramos os servicios necesarios
    fcgi_app app["domain"] do

        target_path        app['target_path']
        document_root      "#{app["target_path"]}/public_html/lists"
        server_alias       app['alias'] if app['alias']
        action             :deploy
        owner              app['user'] || node['app']['phplist']['default_user']       
        group              app['group']|| node['app']['phplist']['default_group'] 
        timeout            "600"
    
        repo_url           app["repo_url"] || node["app"]["phplist"]["default_repo_url"]
        repo_type          app["repo_type"] || node["app"]["phplist"]["default_repo_type"]
        revision           app["revision"] || node["app"]["phplist"]["default_revision"]
        purge_target_path  'yes'

        notifies          :restart, 'service[nginx]'
        notifies          :restart, 'service[php5-fpm]'

    
    end


    
    # creamos o ficheiro de configuracion
    template "#{app['target_path']}/public_html/lists/config/config.php" do

        source      'config.php.erb'
        cookbook    "app_phplist" 
        user        owner
        group       group
        variables(
                    :db_name => app['db_name'],
                    :db_user => app['db_user'],
                    :db_password => app['db_password'],
                    :db_host => app['db_host'],
                    :smtp_server => app['smtp_server'],
                    :smtp_user => app['smtp_user'],
                    :smtp_password => app['smtp_password'],
                    
                    
        )
                    
    end


end
