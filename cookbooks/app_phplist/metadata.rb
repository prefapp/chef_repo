name             "app_phplist"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage phplist installations"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.3"

depends "app_php"
depends "dbs_mysql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty phplist application",
    attributes: [/.+/],
    stackable: true


attribute "app/phplist/installations/@/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/phplist/installations/@/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/phplist/installations/@/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/phplist/installations/@/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "phplist_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/phplist/installations/@/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "phplist_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/phplist/installations/@/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}


attribute "app/phplist/installations/@/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/opt/phplist',
    :validations => {predefined: "unix_path"}

attribute "app/phplist/installations/@/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'phplist',
    :validations => {predefined: "username"}

attribute "app/phplist/installations/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

attribute "app/phplist/installations/@/smtp_server",
    :display_name => "Smtp host",
    :description => "Smtp server to use to send emails, empty to localhost",
    :default => '',
    :required => false,
    :validations => {predefined: "server_name"}

attribute "app/phplist/installations/@/smtp_user",
    :display_name => "Smtp username",
    :description => "Smtp server login account",
    :default => '',
    :required => false,
    :validations => {predefined: "smtp_user"}

attribute "app/phplist/installations/@/smtp_password",
    :display_name => "Smtp user password",
    :description => "Smtp server account password",
    :validations => {predefined: "password"}

