# nginx_passenger_site
define :nginx_passenger_site, :template => 'passenger_site.erb', :enable => true do
  application_name = params[:name]
  static_files_path = params[:static_files_path] 

  port = params[:port] || 80
  service_location = params[:service_location] || '/'
  rack_env = params[:rack_env] || 'production'
  alternative_names = params[:alternative_names] || []

  # nos aseguramos de que se incluan as recetas basicas
  include_recipe "appserver_nginx::with_passenger"
  

  template "#{node['nginx']['dir']}/sites-available/#{application_name}" do
    source              params[:template]
    owner               "root"
    group               "root"
    mode                '0644'
    cookbook            params[:cookbook] || 'appserver_nginx'

    variables(
      :name              => application_name,
      :port              => port,
      :static_files_path => static_files_path,
      :service_location  => service_location,
      :rails_env         => rack_env,
      :alternative_names => alternative_names
    )

  end

  site_enabled = params[:enable]
  nginx_site "#{params[:name]}" do
    enable site_enabled
  end
end
