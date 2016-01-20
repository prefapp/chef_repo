include_recipe "app_phpback::default"

app = node['app']['phpback']

# establecemos valores por defecto
args = Hash.new do |hash,key| 
  hash[key] = app[key] || node["app"]["phpback"]["default_#{key}"]
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

if args['db_type'] == 'mysql'
  extra_packages << 'php5-mysqlnd'
elsif args['db_type'] == 'pgsql'
  extra_packages << 'php5-pgsql'
end

# instalamos a aplicacion e configuramos os servicios necesarios
fcgi_app args["domain"] do

  target_path          args['target_path']
  document_root        args['target_path']
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


#
# tarea de inicializacion da app
#
task = <<"EOF"
cd #{args['target_path']}/install/ && \
([ ! -f install1.php ] || php install1.php 'adminname=#{args['admin_name']}&adminemail=#{args['admin_email']}\
&adminpass=#{args['admin_password']}&adminrpass=#{args['admin_password']}\
&hostname=#{args['db_host']}&username=#{args['db_user']}&password=#{args['db_password']}&database=#{args['db_name']}') && \
([ ! -f install2.php ] || php install2.php 'rpublic=#{args['rpublic']}&rprivate=#{args['rprivate']}&mainmail=#{args['mainmail']}\
&title=#{args['title']}&smtp-host=#{args['smtp-host']}&smtp-port=#{args['smtp-port']}\
&smtp-user=#{args['smtp-user']}&smtp-password=#{args['smtp-password']}\
&maxvotes=#{args['max_votes']}&max_results=#{args['max_results']}&language=#{args['language']}')
EOF


# executamos a task ou creamos o ficheiro para executarse no arranque
# en funcion de si estamos instalando o server mysql ou non
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
