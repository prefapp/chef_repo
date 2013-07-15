name             "appserver_nginx"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.1.0"
description      "Install/Configures nginx httpd server"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "nginx"
depends "runit"
depends "lang_ruby"

recipe "default",
    :description => "Compile nginx from source and install with the specified modules",
    :attributes => [/^(?!.*\/(passenger|php)\/).*$/]
    # :attributes => ['!appserver/nginx/passenger/version', /.+/]

recipe "with_passenger",
    :description => "Compile nginx with passenger support",
    :attributes => [/.+/],
    :dependencies => ["lang_ruby::install"]

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
    :default => '1.4.1', #1.2.9
    :advanced => false,
    :validations => {predefined: "version"}

attribute "appserver/nginx/checksum",
    :display_name => 'Nginx source tarball checksum',
    :description => 'Nginx source tarbal sha256 checksum',
    :default => 'bca5d1e89751ba29406185e1736c390412603a7e6b604f5b4575281f6565d119',#'2457a878943fb409ec4fcb46b43af222d06a584f93228e17a4f02b0e7bfc9de3',
    :validations => {regex: /[0-9a-z]+/}


attribute "appserver/nginx/modules",
    :display_name => 'Nginx modules',
    :description => 'Nginx modules to compile and install with',
    :type => "array",
    :default => ["http_ssl_module", "http_gzip_static_module"],
    :validations => {regex: /\A\w+\z/}

attribute "appserver/nginx/passenger/version",
    :display_name => 'Passenger version',
    :description => 'Passenger version to compile and install with nginx',
    :default => '4.0.8', #'3.0.21',
    :advanced => false,
    :validations => {predefined: "version"}
