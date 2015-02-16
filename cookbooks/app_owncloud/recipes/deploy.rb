include_recipe "app_owncloud::default"

app = node["app"]["owncloud"]

needed_packages = %W{

    php5-gd 
    php5-intl 
    php5-curl 
    php5-json 
    smbclient

}
    
needed_packages << 'php5-sqlite' if app['dbtype'] == 'sqlite'
needed_packages << 'php5-mysql' if app['dbtype'] == 'mysql'
needed_packages << 'php5-pgsql' if app['dbtype'] == 'pgsql'


needed_packages.each do |pkg|
    package pkg
end



# instalamos a aplicacion e configuramos os servicios necesarios
fcgi_app app["domain"] do

    target_path        app['target_path']
    #document_root      "#{app["target_path"]}/owncloud"
    server_alias       app['alias'] if app['alias']
    action             :deploy
    owner              app['user']
    group              app['group']
    timeout            "600"

    repo_url           app["repo_url"]
    repo_type          app["repo_type"]
    revision           app["revision"]
    purge_target_path  'yes'

    cookbook           'app_owncloud'
    frontend_template  'nginx_owncloud.erb'
    
    php_ini_admin_values  "max_upload_size" => app['max_upload_size'],
                          "post_max_size" => app['max_upload_size']

    notifies          :restart, 'service[nginx]'
    notifies          :restart, 'service[php5-fpm]'


end


# directorio de datos
directory app['data_dir'] do
    owner   app['user']
    group   app['group']
    mode    00750
    action  :create
end

# creamos o ficheiro de configuracion
template "#{app['target_path']}/config/autoconfig.php" do

    source      'autoconfig.php.erb'
    cookbook    "app_owncloud" 
    user        app["user"]
    group       app["group"]
    variables   ({
        :app => app,
    })
                
end
