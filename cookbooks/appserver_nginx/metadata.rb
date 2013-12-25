name             "appserver_nginx"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.1.1"
description      "Install/Configures nginx httpd server"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "nginx"
depends "runit"
depends "lang_ruby"

recipe "default",
    :description => "Compile nginx from source and install with the specified modules",
    :attributes => [/^(?!.*\/(passenger|php|reverse_proxy_sites)\/).*$/]
    # :attributes => ['!appserver/nginx/passenger/version', /.+/]

recipe "with_passenger",
    :description => "Compile nginx with passenger support",
    :attributes => [/^(?!.*\/(php|reverse_proxy_sites)\/).*$/],
    :dependencies => ["lang_ruby::install"]

recipe "reverse_proxy",
    :description => "Configure a list of sites where nginx acts as a reverse proxy",
    :attributes => [/\/reverse_proxy_sites\//],
    :stackable => true,
    :dependencies => ["appserver_nginx::default"]

=begin
#RECETA CO FLAG DE stackable A true!!
recipe "add_passenger_site",
    :description => ,
    :attributes => ,
    :dependencies => ["with_passenger"]
=end

#recipe "with_php-fpm",
#    description: "Deploys last stable versions of php5.4 and nginx with php-fpm, from sources",
#    attributes: ['php/version', 'nginx/version', 'nginx/source/checksum'],
#    dependencies: []

## Atributos avanzados
#attribute "appserver/nginx/php/version",
#    :display_name => 'PHP version to compile and install',
#    :description => 'Version to use in the php compilation',
#    :default => '5.4.9',
#    :validations => {predefined: "version"}



attribute "appserver/nginx/install_dir",
    :display_name => 'Nginx installation dir',
    :description => 'Nginx source installation directory',
    :default => '/opt/nginx',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "appserver/nginx/version",
    :display_name => 'Nginx version to install',
    :description => 'Nginx version to compile and install',
    :default => '1.4.3', #1.2.9
    :advanced => false,
    :validations => {predefined: "version"}

attribute "appserver/nginx/checksum",
    :display_name => 'Nginx source tarball checksum',
    :description => 'Nginx source tarbal sha256 checksum',
    :default => 'ae123885c923a6c3f5bab0a8b7296ef21c4fdf6087834667ebbc16338177de84',#'2457a878943fb409ec4fcb46b43af222d06a584f93228e17a4f02b0e7bfc9de3',
    :validations => {regex: /[0-9a-z]+/}


attribute "appserver/nginx/modules",
    :display_name => 'Nginx modules',
    :description => 'Nginx modules to compile and install with',
    :type => "array",
    :default => ["http_ssl_module", "http_gzip_static_module"],
    :validations => {regex: /^\w+$/}

attribute "appserver/nginx/passenger/version",
    :display_name => 'Passenger version',
    :description => 'Passenger version to compile and install with nginx',
    :default => '4.0.19', #'3.0.21',
    :advanced => false,
    :validations => {predefined: "version"}


# atributos de reverse_proxy
attribute "appserver/nginx/reverse_proxy_sites/@/domain",
    :display_name => "Site domain",
    :description => "Domain related to site",
    :default => "test.com",
    :advanced => false,
    :validations => {predefined: "domain"}

attribute "appserver/nginx/reverse_proxy_sites/@/public_port",
    :display_name => "Public Port",
    :description => "Public port where to bind nginx proxy",
    :advanced => false,
    :default => "80",
    :validations => {predefined: "tcp_port"}

attribute "appserver/nginx/reverse_proxy_sites/@/backends",
    :display_name => "List of backend servers",
    :description => "List of backend servers in 'ip:port|hostname:port|unix:path' format",
    :advanced => false,
    :type => "array",
    :default => ["10.0.3.1:8080"],
    :required => true,
    :validations => {predefined: "socket_address" }

attribute "appserver/nginx/reverse_proxy_sites/@/ssl",
    :display_name => 'Use ssl for this site',
    :description => 'Has this site an ssl certificate?',
    :advanced => true,
    :default => "no",
    :choice => ["yes","no"]

attribute "appserver/nginx/reverse_proxy_sites/@/service_path",
    :display_name => 'Service path to map in backend',
    :description => 'Path expected for the service in the backend (primarly for websockets)',
    :default => '/',
    :advanced => true,
    :validations => {predefined: "unix_path"}

