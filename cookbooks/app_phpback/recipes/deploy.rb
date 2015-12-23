include_recipe "app_phpback::default"

app = node['app']['phpback']

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
  admin_user
  admin_password
}.each do |attribute|

  args[attribute] = app[attribute] || node["app"]["phpback"]["default_#{attribute}"]

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

#extra_packages = %w{
#  php5-curl
#  php5-gd 
#  php5-intl
#  php5-xmlrpc
#}
#
#if args['db_type'] == 'mysqli'
#  extra_packages << 'php5-mysqlnd'
#elsif args['db_type'] == 'pgsql'
#  extra_packages << 'php5-pgsql'
#end

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
  cookbook_file        'app_phpback'
  #frontend_template    'nginx_phpback.erb'  
  notifies             :restart, 'service[nginx]', :delayed
  notifies             :restart, 'service[php5-fpm]', :delayed

end


# creamos o ficheiro de configuracion
template "#{args['target_path']}/application/config/database.php" do

  source      'database.php.erb'
  cookbook    "app_phpback" 
  user        args["user"]
  group       args["group"]
  variables   ({:app => args})
                
end

# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
  
  template "#{node['riyic']['extra_tasks_dir']}/phpback_load_db-#{app['domain']}.sh" do

    source 'mysql_aware_tasks.sh.erb'
    mode '0700'
    owner 'root'
    group 'root'
    cookbook 'dbs_mysql'
    variables ({
      :control_file => '/root/.actualizado',
      :db_user => args['db_user'],
      :db_pass => args['db_password'],
      :db_host => args['db_host'],
      :task => "mysql -u #{args['db_user']} -p#{args['db_password']} -h #{args['db_host']} < #{args['target_path']}/install/database_tables.sql"
    })
  end
end
