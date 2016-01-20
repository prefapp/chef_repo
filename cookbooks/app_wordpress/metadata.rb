name             "app_wordpress"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage wordpress installations"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.2"

depends "app_php"
depends "dbs_mysql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty wordpress application",
    attributes: [/.+/]


attribute "app/wordpress/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/wordpress/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/wordpress/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/wordpress/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "wordpress_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/wordpress/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "wordpress_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/wordpress/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}


attribute "app/wordpress/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/wordpress',
    :validations => {predefined: "unix_path"}

attribute "app/wordpress/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'wordpress',
    :validations => {predefined: "username"}

attribute "app/wordpress/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

attribute "app/wordpress/smtp_server",
    :display_name => "Smtp host",
    :description => "Smtp server to use to send emails, empty to localhost",
    :default => '',
    :required => false,
    :validations => {predefined: "server_name"}

attribute "app/wordpress/smtp_user",
    :display_name => "Smtp username",
    :description => "Smtp server login account",
    :default => '',
    :required => false,
    :validations => {predefined: "smtp_user"}

attribute "app/wordpress/smtp_password",
    :display_name => "Smtp user password",
    :description => "Smtp server account password",
    :validations => {predefined: "password"}

attribute "app/wordpress/smtp_server_secure",
    :display_name => "Enable SMTP secure connection?",
    :description => "Use TLS in smtp server connection",
    :default => 'yes',
    :required => false,
    :choice => %w{yes no}
