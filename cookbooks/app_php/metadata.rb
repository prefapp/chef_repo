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

recipe "with_mysql_db",
    description: "Deploys a generic php application with a Mysql Database from a git/svn repository",
    attributes: [/.+/]


## Atributos xenerais
attribute "app_php/dir",
    :display_name => 'Application Installation Directory',
    :description => 'Application Installation Directory',
    :advanced => false,
    :default => '/var/www/test',
    :validations => {predefined: "unix_path"}


attribute "app_php/domain",
    :display_name => 'Application Domain Name',
    :description => 'Virtual hosting Domain Name asociated to application',
    :advanced => false,
    :default => "my_site_domain.com",
    :required => true,
    :validations => {predefined: "domain"}

attribute "app_php/server_aliases",
    :display_name => "Domain aliases for the applications" ,
    :description => "Array of domain aliases for the application",
    :type => "array",
    :default => [],
    :required => false,
    :validations => {predefined: "domain"}


attribute "app_php/config_template",
    :display_name => "Application config template" ,
    :description => "Template settings of the application",
    :default => "",
    :validations => {predefined: "multiline_text"}


## atributos de source-control-management
attribute "app_php/scm/repo",
    :display_name => 'Application Repository Path',
    :description => 'GIT or Subversion Repo Path of the application',
    :advanced => false,
    :default => "http://my_repo_url.com",
    :required => true,
    :validations => {predefined: "url"}

attribute "app_php/scm/revision",
    :display_name => 'Application Revision Name',
    :description => 'Revion or tag name of the application version to deploy',
    :advanced => false,
    :default => "master",
    :required => true,
    :validations => {predefined: "revision"}


# atributos da bbdd mysql
attribute "app_php/mysql/db_name",
    :display_name => "Application Database Name",
    :description => "Mysql Database name for the application",
    :advanced => false,
    :validations => {predefined: "mysql_dbname"}

attribute "app_php/mysql/db_user",
    :display_name => "Mysql Database User Name" ,
    :description => "Mysql Database username for the application",
    :advanced => false,
    :validations => {predefined: "mysql_dbuser"}


attribute "app_php/mysql/db_password",
    :display_name => "Mysql Database Password" ,
    :description => "Mysql Database password for the application",
    :calculated => true,
    :advanced => false,
    :validations => {predefined: "mysql_dbpassword"}


attribute "app_php/mysql/db_host",
    :display_name => "Mysql Database Hostname" ,
    :description => "Application Mysql Database Hostname",
    :default => 'localhost',
    :validations => {predefined: "host"}



