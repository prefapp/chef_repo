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

extra_packages = []
#extra_packages = %w{
#  php5-curl
#  php5-gd 
#  php5-intl
#  php5-xmlrpc
#}
#

if args['db_type'] == 'mysql'
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
  cookbook            'app_phpback'
  frontend_template    'nginx_phpback.erb'  
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
#if node["riyic"]["inside_container"]
#  
#  template "#{node['riyic']['extra_tasks_dir']}/phpback_load_db-#{app['domain']}.sh" do
#
#    source 'mysql_aware_tasks.sh.erb'
#    mode '0700'
#    owner 'root'
#    group 'root'
#    cookbook 'dbs_mysql'
#    variables ({
#      :control_file => '/root/.actualizado',
#      :db_user => args['db_user'],
#      :db_pass => args['db_password'],
#      :db_host => args['db_host'],
#      :task => "mysql -u #{args['db_user']} -p#{args['db_password']} -h #{args['db_host']} #{args['db_name']} < #{args['target_path']}/install/database_tables.sql"
#    })
#  end
#end

task = <<"EOF"
php #{args['target_path']}/install/install1.php \
'adminname=#{args['admin_name']}&adminemail=#{args['admin_email']}\
&adminpass=#{args['admin_password']}&adminrpass=#{args['admin_password']}\
&hostname=#{args['db_host']}&username=#{args['db_user']}&password=#{args['db_pass']}&database=#{args['db_name']}' && \
php #{args['target_path']}/install/install2.php \
'rpublic=#{args['rpublic']}&rprivate=#{args['rprivate']}&mainmail=#{args['mainmail']}\
&title=#{args['title']}&smtp-host=#{args['smtp-host']}&smtp-port=#{args['smtp-port']}\
&smtp-user=#{args['smtp-user']}&smtp-password=#{args['smtp-password']}\
&maxvotes=#{args['max_votes']}&max_results=#{args['max_results']}&language=#{args['language']}'
EOF


# executamos a task ou creamos o ficheiro para executarse no arranque
execute "installation_script" do
  command task
  only_if {node.recipe?('dbs_mysql::server')}
end


file "#{node['riyic']['extra_tasks_dir']}/phpback_installation-#{args['domain']}.sh" do
  mode '0700'
  owner 'root'
  group 'root'
  content task 
   
  not_if {node.recipe?('dbs_mysql::server')}
end
