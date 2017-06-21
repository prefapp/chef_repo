name             "app_moodle"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage moodle installations"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

depends "app_php"
depends "dbs_mysql"
depends "dbs_postgresql"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a tasty moodle application",
    attributes: [/.+/],
    dependencies: %w{lang_php::default}


attribute "app/moodle/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/moodle/alias",
    :display_name => 'Application domain alias',
    :description => 'Other domains associated to app virtual host',
    :default => [],
    :type => "array",
    :validations => {predefined: "domain"}


attribute "app/moodle/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "server_name"}


attribute "app/moodle/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "moodle_db",
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "app/moodle/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "moodle_user",
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "app/moodle/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "mysql_dbpassword"}

attribute "app/moodle/db_type",
    :display_name => "Database type",
    :description => "Database type valid values: pgsql, mysqli, mariadb, mssql, sqlsrv, oci",
    :required => true,
    :default => 'pgsql',
    :choice => %w{pgsql mariadb mysqli mssql sqlsrv oci}

attribute "app/moodle/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/moodle/public',
    :validations => {predefined: "unix_path"}

attribute "app/moodle/datadir",
    :display_name => "Moodle data directory",
    :description => 'The directory where moodle store data',
    :default => '/home/moodle/moodledata',
    :validations => {predefined: "unix_path"}

attribute "app/moodle/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'moodle',
    :validations => {predefined: "username"}

attribute "app/moodle/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

attribute "app/moodle/smtp_server",
    :display_name => "Smtp host",
    :description => "Smtp server to use to send emails, empty to localhost",
    :default => '',
    :required => false,
    :validations => {predefined: "server_name"}

attribute "app/moodle/smtp_user",
    :display_name => "Smtp username",
    :description => "Smtp server login account",
    :default => '',
    :required => false,
    :validations => {predefined: "smtp_user"}

attribute "app/moodle/smtp_password",
    :display_name => "Smtp user password",
    :description => "Smtp server account password",
    :validations => {predefined: "password"}

attribute "app/moodle/smtp_server_secure",
    :display_name => "Enable SMTP secure connection?",
    :description => "Use TLS in smtp server connection",
    :default => 'yes',
    :required => false,
    :choice => %w{yes no}

attribute "app/moodle/admin_user",
    :display_name => "Admin user",
    :description => 'Admin user name',
    :required => true,
    :default => 'admin',
    :validations => {predefined: "username"}

attribute "app/moodle/admin_password",
    :display_name => "Admin user password",
    :description => 'Admin user password',
    :required => true,
    :calculated => true,
    :validations => {predefined: "password"}


attribute "app/moodle/max_upload_size",
    :display_name => 'Maximum upload size in MB',
    :description => 'Max size of uploadable file in MB',
    :default => '120',
    :validations => {predefined: "int"},
    :advanced => true
