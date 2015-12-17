name             "app_owncloud"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage owncloud"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.3"

depends "app_php"
depends "dbs_mysql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty owncloud application",
    attributes: [/.+/]
    #stackable: true


attribute "app/owncloud/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/owncloud/version",
    :display_name => 'Owncloud version',
    :description => 'Owncloud version to install',
    :default => 'latest',
    :advanced => false,
    :required => true,
    :choice => ['latest','8.1.2', '8.0.7','7.0.9','6.0.9']

attribute "app/owncloud/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}

attribute "app/owncloud/adminlogin",
    :display_name => "Owncloud admin user",
    :description => 'Admin user in owncloud app',
    :required => true,
    :default => 'admin',
    :validations => {predefined: "username"}

attribute "app/owncloud/adminpass",
    :display_name => "Owncloud admin user password",
    :description => 'Owncloud admin user password',
    :required => true,
    :calculated => true,
    :validations => {predefined: "password"}

attribute "app/owncloud/smtp_server",
    :display_name => "Smtp host",
    :description => "Smtp server to use to send emails, empty to localhost",
    :default => '',
    :required => false,
    :validations => {predefined: "server_name"}

attribute "app/owncloud/smtp_user",
    :display_name => "Smtp username",
    :description => "Smtp server login account",
    :default => '',
    :required => false,
    :validations => {predefined: "smtp_user"}

attribute "app/owncloud/smtp_password",
    :display_name => "Smtp user password",
    :description => "Smtp server account password",
    :validations => {predefined: "password"}


attribute "app/owncloud/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/owncloud/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "owncloud_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/owncloud/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "owncloud_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/owncloud/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}

attribute "app/owncloud/db_type",
    :display_name => "Database type",
    :description => "Database type valid values: sqlite, mysql or pgsql",
    :required => true,
    :default => 'sqlite',
    :choice => %w{sqlite mysql pgsql}

attribute "app/owncloud/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/owncloud',
    :validations => {predefined: "unix_path"}

attribute "app/owncloud/datadir",
    :display_name => "Owncloud file storage path",
    :description => 'Owncloud will store files in this folder',
    :default => '/home/owncloud/ownclouddata',
    :validations => {predefined: "unix_path"}

attribute "app/owncloud/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owncloud',
    :validations => {predefined: "username"}

attribute "app/owncloud/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

