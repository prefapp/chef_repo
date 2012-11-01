maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "All rights reserved"
description      "Cookbook for the deploy of php apps"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []

recipe "app_with_mysqldb",
    description: "Deploys a generic php application with a Mysql Database",
    attributes: [/.+/],
    stackable: true


## Atributes
attribute "app_php/dir",
    :display_name => 'Application Installation Directory',
    :description => 'Application Installation Directory',
    :advanced => false,
    :validations => {regex: /\A\w+\z/}


attribute "app_php/mysql/db_name",
    :display_name => "Application Database Name",
    :description => "Mysql Database name for the application",
    :advanced => false,
    :validations => {regex: /\A\w+\z/}

attribute "app_php/mysql/db_user",
    :display_name => "Mysql Database User Name" ,
    :description => "Mysql Database username for the application",
    :advanced => false,
    :validations => {regex: /\A\w+\z/}


attribute "app_php/mysql/db_password",
    :display_name => "Mysql Database Password" ,
    :description => "Mysql Database password for the application",
    :calculated => true,
    :default_value => 'random',
    :validations => {regex: /\A\w+\z/}


attribute "app_php/mysql/db_host",
    :display_name => "Mysql Database Hostname" ,
    :description => "Application Mysql Database Hostname",
    :default => 'localhost',
    :validations => {regex: /\A\w+\z/}

