maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "All rights reserved"
description      "Cookbook for deploy a php webstack"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []

recipe "apache-php5.3",
    description: "Deploys php5.3 and apache with mod_php, from distribution packages",
    attributes: [],
    dependencies: ['webserver_apache']

recipe "nginx-php_source",
    description: "Deploys last stable versions of php5.4 and nginx with php-fpm, from sources",
    attributes: ['php/version', 'nginx/version', 'nginx/source/checksum'],
    dependencies: []

## Atributos avanzados
attribute "php/version",
    :display_name => 'PHP version to compile and install',
    :description => 'Version to use in the php compilation',
    :default => '5.4.9',
    :validations => {regex: /^\d+\.\d+\.\d+/}


attribute "nginx/version",
    :display_name => 'Nginx version to install',
    :description => 'Nginx version to compile and install',
    :default => '1.2.6',
    :validations => {regex: /^\d+\.\d+\.\d+/}


attribute "nginx/source/checksum",
    :display_name => 'Nginx source tarball checksum',
    :description => 'Nginx source tarbal sha512 checksum',
    :default => '0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388',
    :validations => {regex: /[0-9a-z]+/}

