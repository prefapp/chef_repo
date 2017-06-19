include_recipe "app_moodle::default"

app = node['app']['moodle']

args = {}

%W{
  domain
  target_path
  user
  group
  repo_url
  repo_type
  revision
  db_name
  db_user
  db_host
  db_password
  db_type
  datadir
  admin_user
  admin_password
}.each do |attribute|

  args[attribute] = app[attribute] || node["app"]["moodle"]["default_#{attribute}"]

end

# npi se fai falta
php_ini_config = {
  'upload_max_filesize' => '50M',
  'post_max_size' => '55M',
  
  'opcache.enable' => 1,
  'opcache.memory_consumption' => 128,
  'opcache.max_accelerated_files' =>  4000,
  'opcache.revalidate_freq' => 60,
}
###

# seteamos os paquetes necesarios de php segun a version 
# que se vai a instalar
php_version = node["lang"]["php"]["version"]

if php_version == "5.5"
  php_version = "5"
end



extra_packages = %W{
  graphviz
  aspell
  php#{php_version}-curl
  php#{php_version}-gd 
  php#{php-version}-intl
  php#{php-version}-xml
  php#{php-version}-xmlrpc
  php#{php-version}-ldap
  php#{php-version}-zip
  php#{php-version}-pspell
}

if args['db_type'] == 'mysqli'
  extra_packages << "php#{php_version}-mysql"
elsif args['db_type'] == 'pgsql'
  extra_packages << "php#{php_version}-pgsql"
end

# instalamos a aplicacion e configuramos os servicios necesarios
fcgi_app args["domain"] do

  target_path          args['target_path']
  document_root        args["target_path"]
  server_alias         args['alias'] if args['alias']
  action               :deploy
  owner                args['user']
  group                args['group']
  timeout              "600"
  
  repo_url             args["repo_url"]
  repo_type            args["repo_type"]
  revision             args["revision"]
  purge_target_path    'yes'
  
  extra_packages       extra_packages
  
  php_ini_admin_values (php_ini_config)
  cookbook	           'app_moodle'
  frontend_template    'nginx_moodle.erb'  
  notifies             :restart, 'service[nginx]', :delayed
  notifies             :restart, 'service[php5-fpm]', :delayed

end

# creamos o directorio de datos do moodle
directory args['datadir'] do
  action :create
  mode 0777
  user args['user']
  group args['group']
end

# creamos o ficheiro de configuracion
template "#{args['target_path']}/config.php" do

  source      'config.php.erb'
  cookbook    "app_moodle" 
  user        args["user"]
  group       args["group"]
  variables   ({:app => args})
                
end

# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
    
    file "#{node['riyic']['extra_tasks_dir']}/moodle-#{app['domain']}.sh" do

        mode '0700'
        owner 'root'
        group 'root'

        content %{
if [ ! -f /root/.actualizado ]
then
  su -c 'service mysql start'
  su -c 'cd #{app['target_path']} && /usr/bin/php admin/cli/install_database.php --lang=es --adminuser=#{app['admin_user']} --adminpass=#{app['admin_password']} --agree-license' #{app['user']}
  su -c 'service mysql stop'
  su -c 'touch /root/.actualizado'
fi
}
    end
end
