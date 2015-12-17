include_recipe "app_owncloud::default"

app = node['app']['owncloud']

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

  args[attribute] = app[attribute] || node["app"]["owncloud"]["default_#{attribute}"]

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

extra_packages = %w{
  php5-curl
  php5-gd 
  php5-intl
  php5-xmlrpc
}

if args['db_type'] == 'mysqli'
  extra_packages << 'php5-mysqlnd'
elsif args['db_type'] == 'pgsql'
  extra_packages << 'php5-pgsql'
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
  cookbook	     'app_owncloud'
  frontend_template  'nginx_owncloud.erb'  
  notifies             :restart, 'service[nginx]', :delayed
  notifies             :restart, 'service[php5-fpm]', :delayed

end

# creamos o directorio de datos do owncloud
directory args['datadir'] do
  action :create
  mode 0777
  user args['user']
  group args['group']
end

# creamos o ficheiro de configuracion
template "#{args['target_path']}/config.php" do

  source      'config.php.erb'
  cookbook    "app_owncloud" 
  user        args["user"]
  group       args["group"]
  variables   ({:app => args})
                
end

# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
    
    file "#{node['riyic']['extra_tasks_dir']}/owncloud-#{app['domain']}.sh" do

        mode '0700'
        owner 'root'
        group 'root'

        content %{
}
    end
end
