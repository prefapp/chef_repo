name             "app_php"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "All rights reserved"
description      "Cookbook for the deploy php apps"
version          "0.1.1"


depends "lang_php"
depends "appserver_nginx"
depends "appserver_fpm"
depends "code_repo"

%w{debian ubuntu}.each do |os|
  supports os
end

#
#recetas
#
recipe "default",
    description: "empty",
    attributes: []

recipe "fcgi_app",
    description: "Deploy a php app from repository to be served with nginx+php-fpm",
    attributes: [/^app\/php\/fcgi_apps\//],
    dependencies: ["lang_php::default", "appserver_nginx::default", "appserver_fpm::default"],
    stackable: true

#
# atributos
#

attribute "app/php/fcgi_apps/@/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/php/fcgi_apps/@/server_alias",
    :display_name => 'Domain aliases',
    :description => 'Application aliases to respond to in host request',
    :type => "array",
    :default => [],
    :validations => {predefined: "domain"}

attribute "app/python/fcgi_apps/@/environment",
    :display_name => 'Application environment',
    :description => 'Application Environment',
    :default => 'production',
    :advanced => false,
    :required => true,
    :validations => {predefined: "word"}

attribute "app/php/fcgi_apps/@/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/owner/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/php/fcgi_apps/@/entry_point",
    :display_name => "Application entry point script",
    :description => 'Script to start the application',
    :default => 'app.wsgi',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/php/fcgi_apps/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "app/php/fcgi_apps/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}


attribute "app/php/fcgi_apps/@/repo_url",
    :display_name => 'Repository source code url',
    :description => 'Repository url from which to download source code',
    :advanced => false,
    :required => true,
    :default => "http://my-repo-url.com",
    :validations => {predefined: "url"}


attribute "app/php/fcgi_apps/@/repo_type",
    :display_name => "Repository type",
    :description => 'Repository type from which to download application code',
    :default => 'git',
    :advanced => false,
    :choice => ["git", "subversion","remote_archive"]

attribute "app/php/fcgi_apps/@/revision",
    :display_name => 'Application Repository revision',
    :description => 'Application repository tag/branch/commit/archive_name to download',
    :default => "HEAD",
    :validations => {predefined: "revision"}


attribute "app/php/fcgi_apps/@/credential",
    :display_name => 'Repository remote user credential',
    :description => 'Application repository remote user credential',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}


attribute "app/php/fcgi_apps/@/migration_command",
    :display_name => 'Migration command',
    :description => 'Command to run to migrate application to current state',
    :default => "",
    :validations => {predefined: "unix_command"}

attribute "app/php/fcgi_apps/@/extra_modules",
    :display_name => 'Extra PEAR/PECL modules needed',
    :description => 'Extra PEAR/PECL modules needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}

attribute "app/php/fcgi_apps/@/extra_packages",
    :display_name => 'Extra system packages',
    :description => 'Extra system packages needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}


attribute "app/php/fcgi_apps/@/postdeploy_script",
    :display_name => 'Bash script with extra tasks to run',
    :description => 'Script with extra tasks to run after deploy (relative path from target_path)',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/php/fcgi_apps/@/static_files_path",
    :display_name => 'Path to static files',
    :description => 'Path to static files (relative from target_path). Can be empty',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/php/fcgi_apps/@/timeout",
    :display_name => 'Request execution timeout',
    :description => 'Max execution time for requests (in seconds)',
    :default => 120,
    :validations => {predefined: "int"}

attribute "app/php/fcgi_apps/@/purge_target_path",
    :display_name => "Delete target_path folder before deploy",
    :description => "Delete 'target_path' folder before download application code",
    :default => 'no'

 attribute "app/php/fcgi_apps/@/repo_depth",
    :display_name => "Number of past revisions to download (git)",
    :description => "The number of past revisions that will be included in the git shallow clone. The default behavior will do a full clone.",
    :default => 0,
    :validations => {predefined: "int"}
