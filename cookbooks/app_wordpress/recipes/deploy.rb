include_recipe "app_wordpress::default"
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)


app = node['app']['wordpress']

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
  debug
  debug_log
  system_lang

}.each do |attribute|

  args[attribute] = app[attribute] || node["app"]["wordpress"]["default_#{attribute}"]

end

php_ini_config = {
  'upload_max_filesize' => '150M',
  'post_max_size' => '155M',

  'opcache.enable' => 1,
  'opcache.memory_consumption' => 128,
  'opcache.max_accelerated_files' =>  4000,
  'opcache.revalidate_freq' => 60,
}


# seteamos os paquetes necesarios de php segun a version 
# que se vai a instalar
php_version = node["lang"]["php"]["version"]

if php_version == "5.5"
  php_version = "5"
end

extra_packages = ["php#{php_version}-curl","php#{php_version}-mysqlnd"]

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

  cookbook	           'app_wordpress'
  frontend_template    'nginx_wordpress.erb'
  notifies             :restart, 'service[nginx]', :delayed

end

=begin
Desactivado ca nova version do archivo de config

# generamos as keys para as cookies se non nolas pasan
args['auth_key'] = app['auth_key'] || secure_password
args['nonce_key'] = app['nonce_key'] || secure_password
args['secure_auth_key'] = app['secure_auth_key'] || secure_password
args['logged_in_key'] = app['logged_in_key'] || secure_password
args['auth_salt'] = app['auth_salt'] || secure_password
args['secure_auth_salt'] = app['secure_auth_salt'] || secure_password
args['logged_in_salt'] = app['logged_in_salt'] || secure_password
args['nonce_salt'] = app['nonce_salt'] || secure_password


# debug mode
args['debug'] = (app['enable_debug'] =~ /^y|s/i)? true : false
args['debug_log'] = (app['enable_debug_log'] =~ /^y|s/i)? true : false

=end

# creamos o ficheiro de configuracion
template "#{args['target_path']}/wp-config.php" do

  source      'wp-config_new.php.erb'
  cookbook    "app_wordpress"
  user        args["user"]
  group       args["group"]
  variables   ({:app => args})

end

# extra_tasks para o arranque do container
# que setee o propietario correcto no volumen de uploads
#
if node["riyic"]["inside_container"]

  file "#{node['riyic']['extra_tasks_dir']}/wordpress_correct_uploads_owner.sh" do
    mode '0700'
    owner 'root'
    group 'root'
    content "chown -R #{args['user']}:#{args['group']} #{args['target_path']}/wp-content/uploads"
  end

end
