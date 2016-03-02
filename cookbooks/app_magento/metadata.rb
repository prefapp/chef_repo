name             "app_magento"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage magento installations"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

depends "app_php"
depends "dbs_mysql"
depends "dbs_postgresql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty magento application",
    attributes: [/.+/]


attribute "app/magento/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/magento/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/magento/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/magento/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "magento_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/magento/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "magento_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/magento/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}

attribute "app/magento/db_type",
    :display_name => "Database type",
    :description => "Database type valid values: pgsql, mysqli, mariadb, mssql, sqlsrv, oci",
    :required => true,
    :default => 'pgsql',
    :choice => %w{pgsql mariadb mysqli mssql sqlsrv oci}

attribute "app/magento/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/magento/public',
    :validations => {predefined: "unix_path"}

attribute "app/magento/datadir",
    :display_name => "Moodle data directory",
    :description => 'The directory where magento store data',
    :default => '/home/magento/magentodata',
    :validations => {predefined: "unix_path"}

attribute "app/magento/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'magento',
    :validations => {predefined: "username"}

attribute "app/magento/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

attribute "app/magento/smtp_server",
    :display_name => "Smtp host",
    :description => "Smtp server to use to send emails, empty to localhost",
    :default => '',
    :required => false,
    :validations => {predefined: "server_name"}

attribute "app/magento/smtp_user",
    :display_name => "Smtp username",
    :description => "Smtp server login account",
    :default => '',
    :required => false,
    :validations => {predefined: "smtp_user"}

attribute "app/magento/smtp_password",
    :display_name => "Smtp user password",
    :description => "Smtp server account password",
    :validations => {predefined: "password"}

attribute "app/magento/smtp_server_secure",
    :display_name => "Enable SMTP secure connection?",
    :description => "Use TLS in smtp server connection",
    :default => 'yes',
    :required => false,
    :choice => %w{yes no}

attribute "app/magento/admin_user",
    :display_name => "Admin user",
    :description => 'Admin user name',
    :required => true,
    :default => 'admin',
    :validations => {predefined: "username"}

attribute "app/magento/admin_password",
    :display_name => "Admin user password",
    :description => 'Admin user password',
    :required => true,
    :calculated => true,
    :validations => {predefined: "password"}

