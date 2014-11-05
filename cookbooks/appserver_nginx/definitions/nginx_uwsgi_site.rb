# nginx_uwsgi_site

define :nginx_uwsgi_site, :template => 'uwsgi_site.erb', :protocol => 'python', :enable => true do

  application_name = params[:name]
  static_files_path = params[:static_files_path]

  port = params[:port] || 80
  service_location = params[:service_location] || '/'
  uwsgi_socket = params[:uwsgi_socket]
  timeout = params[:uwsgi_read_timeout] || 60

  # parametros do protocolo uwsgi
  # http://uwsgi-docs.readthedocs.org/en/latest/Protocol.html
  uwsgi_modifier1 = 0
  uwsgi_modifier2 = 0

  case params[:protocol] 
  when "perl"
    uwsgi_modifier1 = 5 
  when "ruby"
    uwsgi_modifier1 = 7
  when "php"
    uwsgi_modifier1 = 14
  when "cgi"
    uwsgi_modifier1 = 9
  when "go"
    uwsgi_modifier1 = 11
  when "lua"
    uwsgi_modifier1 = 6
  when "jvm"
    uwsgi_modifier1 = 8
  when "python"
    if service_location == '/'
      uwsgi_modifier1 = 0
    else
      uwsgi_modifier1 = 30
    end
  end

  # nos aseguramos de que se incluan as recetas basicas
  include_recipe 'appserver_nginx::default'

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
      :uwsgi_modifier1   => uwsgi_modifier1,
      :uwsgi_modifier2   => uwsgi_modifier2,
      :static_files_path => static_files_path,
      :service_location  => service_location,
      :uwsgi_read_timeout => timeout 
    )
  end

  site_enabled = params[:enable]
  nginx_site "#{params[:name]}" do
    enable site_enabled
  end
end
