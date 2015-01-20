name             "app_phplist"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage odoo (openerp) installations"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "app_php"
depends "dbs_mysql"
depends "code_repo"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "deploy",
    description: "Deploy a phplist installation",
    attributes: [/.+/]


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


attribute "app/phplist/installations/@/admin_passwd",
    :display_name => "Phplist admin password",
    :description => "Phplist admin password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "password"}


attribute "app/phplist/installations/@/data_dir",
    :display_name => "Data directory",
    :description => "phplist data directory",
    :required => true,
    :default => "/opt/odoo/data",
    :validations => {predefined: "unix_path"}



attribute "app/odoo/installations/@/db_host",
    :display_name => "Database host",
    :description => "Database host",
    :default => "db",
    :required => true,
    :validations => {predefined: "hostname"}


attribute "app/odoo/installations/@/db_name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "odoo_db",
    :required => true,
    :validations => {predefined: "postgresql_identifier"}

attribute "app/odoo/installations/@/db_user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "odoo_user",
    :required => true,
    :validations => {predefined: "postgresql_identifier"}

attribute "app/odoo/installations/@/db_password",
    :display_name => "Database user password",
    :description => "Database user password",
    :required => true,
    :calculated => true,
    :validations => {predefined: "db_password"}


attribute "app/odoo/installations/@/environment",
    :display_name => 'Application environment',
    :description => 'Application Environment',
    :default => 'production',
    :required => true,
    :validations => {predefined: "word"}

attribute "app/odoo/installations/@/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/opt/odoo',
    :validations => {predefined: "unix_path"}

attribute "app/odoo/installations/@/entry_point",
    :display_name => "Application entry point script",
    :description => 'Script to start the application',
    :default => 'openerp-wsgi.py',
    :validations => {predefined: "unix_path"}

attribute "app/odoo/installations/@/repo_url",
    :display_name => 'Repository source code url',
    :description => 'Repository url from which to download source code',
    :required => true,
    :default => "http://my-repo-url.com",
    :validations => {predefined: "url"}

attribute "app/odoo/installations/@/repo_type",
    :display_name => "Repository type",
    :description => 'Repository type from which to download application code',
    :default => 'git',
    :choice => ["git", "subversion","remote_archive"]

attribute "app/odoo/installations/@/revision",
    :display_name => 'Application Repository revision',
    :description => 'Application repository tag/branch/commit/archive_name to download',
    :default => "8.0",
    :validations => {predefined: "revision"}

attribute "app/odoo/installations/@/credential",
    :display_name => 'Repository remote user credential',
    :description => 'Application repository remote user credential',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "app/odoo/installations/@/user",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'odoo',
    :validations => {predefined: "username"}

attribute "app/odoo/installations/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'users',
    :validations => {predefined: "username"}

