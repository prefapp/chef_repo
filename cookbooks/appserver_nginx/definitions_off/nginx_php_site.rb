# nginx_php_site

define :nginx_php_site, :template => 'php_site.erb', :enable => true do

  application_name = params[:name]
  static_files_path = params[:static_files_path] 

  port = params[:port] || 80
  service_location = params[:service_location] || '/'
  fpm_socket = params[:uwsgi_socket] || node["lang_php"]["fpm"]["socket"]


  # nos aseguramos de que se incluan as recetas basicas
  include_recipe 'appserver_nginx::default'
  include_recipe 'lang_php::fpm'


  template "#{node['nginx']['dir']}/sites-available/#{application_name}" do
    source   params[:template]
    owner    "root"
    group    "root"
    mode     '0644'
    cookbook params[:cookbook] || 'appserver_nginx'
    variables(
      :name              => application_name,
      :port              => port,
      :uwsgi_socket      => uwsgi_socket,
      :static_files_path => static_files_path,
      :service_location  => service_location
    )
    # if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{application_name}.conf")
    #   notifies :reload, 'service[apache2]'
    # end
  end

  site_enabled = params[:enable]
  nginx_site "#{params[:name]}" do
    enable site_enabled
  end
end
