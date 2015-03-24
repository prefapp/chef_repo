name             "app_wordpress"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage wordpress installations"
version          "0.1.0"

depends "app_php"
depends "dbs_mysql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty wordpress application",
    attributes: [/.+/],
    stackable: true


attribute "app/phplist/installation/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/phplist/installation/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/phplist/installation/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/phplist/installation/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "phplist_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/phplist/installation/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "phplist_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/phplist/installation/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}


attribute "app/phplist/installation/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/phplist',
    :validations => {predefined: "unix_path"}

attribute "app/phplist/installation/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'phplist',
    :validations => {predefined: "username"}

attribute "app/phplist/installation/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

