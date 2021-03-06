include_recipe "app_owncloud::default"

# establecemos valores por defecto
app = Hash.new do |hash,key| 
  hash[key] = node["app"]["owncloud"][key] || node["app"]["owncloud"]["default_#{key}"]
end


needed_packages = %W{
  php5-gd 
  php5-intl 
  php5-curl 
  php5-json 
  smbclient
}
  
needed_packages << 'php5-sqlite' if app['db_type'] == 'sqlite'
needed_packages << 'php5-mysqlnd' if app['db_type'] == 'mysqli'
needed_packages << 'php5-pgsql' if app['db_type'] == 'pgsql'


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
  
  php_ini_admin_values  "upload_max_filesize" => app['max_upload_size'],
                        "post_max_size" => app['max_upload_size']

  notifies          :restart, 'service[nginx]'
  notifies          :restart, 'service[php5-fpm]'


end


# directorio de datos
directory app['datadir'] do
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


#
# tarea de inicializacion da app
#
control_file = "/root/control_owncloud_#{app['domain']}"

task = <<"EOF"
[ -f #{control_file} ] || (su -c 'cd #{app['target_path']} && php occ maintenance:install \
--database="#{app['db_type']}" --database-name="#{app['db_name']}" \
--database-host="#{app['db_host']}" --database-user="#{app['db_user']}" --database-pass="#{app['db_password']}" \
--admin-user="#{app['admin_user']}" --admin-pass="#{app['admin_password']}" --data-dir="#{app['datadir']}"' #{app['user']} \
&& touch #{control_file})
EOF
  
# executamos a task ou creamos o ficheiro para executarse no arranque
# en funcion de si estamos instalando o server mysql ou non
execute "installation_script" do
  command task
  only_if {node.recipe?('dbs_mysql::server')}
end


file "#{node['riyic']['extra_tasks_dir']}/owncloud_installation-#{app['domain']}.sh" do
  mode '0700'
  owner 'root'
  group 'root'
  content task 
   
  not_if {node.recipe?('dbs_mysql::server')}
end
