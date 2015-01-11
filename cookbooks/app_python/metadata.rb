name             "app_python"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to deploy python wsgi applications"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

depends "lang_python"
depends "appserver_nginx"
depends "appserver_uwsgi"
depends "code_repo"

depends "riyic" # para o base hwrp

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []


recipe "wsgi_app",
    description: "Deploy a wsgi app from repository with nginx+uwsgi support",
    attributes: [/^app\/python\/wsgi_apps\//],
    dependencies: ["lang_python::default", "appserver_nginx::default", "appserver_uwsgi::python"],
    stackable: true

attribute "app/python/wsgi_apps/@/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/python/wsgi_apps/@/server_alias",
    :display_name => 'Domain aliases',
    :description => 'Application aliases to respond to in host request',
    :type => "array",
    :default => [],
    :validations => {predefined: "domain"}

attribute "app/python/wsgi_apps/@/environment",
    :display_name => 'Application environment',
    :description => 'Application Environment',
    :default => 'production',
    :advanced => false,
    :required => true,
    :validations => {predefined: "word"}

attribute "app/python/wsgi_apps/@/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/owner/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/python/wsgi_apps/@/entry_point",
    :display_name => "Application entry point script",
    :description => 'Script to start the application',
    :default => 'app.wsgi',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/python/wsgi_apps/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "app/python/wsgi_apps/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}


attribute "app/python/wsgi_apps/@/repo_url",
    :display_name => 'Repository source code url',
    :description => 'Repository url to download source code',
    :advanced => false,
    :required => true,
    :default => "http://my-repo-url.com",
    :validations => {predefined: "url"}


attribute "app/python/wsgi_apps/@/repo_type",
    :display_name => "Repository type",
    :description => 'Repository type to download application code',
    :default => 'git',
    :advanced => false,
    :choice => ["git", "subversion","remote_archive"]

attribute "app/python/wsgi_apps/@/revision",
    :display_name => 'Application Repository revision',
    :description => 'Application repository tag/branch/commit/archive_name to download',
    :default => "HEAD",
    :validations => {predefined: "revision"}


attribute "app/python/wsgi_apps/@/credential",
    :display_name => 'Repository remote user credential',
    :description => 'Application repository remote user credential',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}

attribute "app/python/wsgi_apps/@/migration_command",
    :display_name => 'Migration command',
    :description => 'Command to run to migrate application to current state',
    :default => "",
    :validations => {predefined: "unix_command"}


attribute "app/python/wsgi_apps/@/requirements_file",
    :display_name => 'Requirements file',
    :description => 'Specify application requirements in a pip requirements file',
    :advanced => false,
    :default => "requirements.txt",
    :required => false,
    :validations => {predefined: "unix_path"}


attribute "app/python/wsgi_apps/@/extra_modules",
    :display_name => 'Extra python pip modules',
    :description => 'Extra python modules needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "python_package"}

attribute "app/python/wsgi_apps/@/extra_packages",
    :display_name => 'Extra system packages',
    :description => 'Extra system packages needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}


attribute "app/python/wsgi_apps/@/postdeploy_script",
    :display_name => 'Bash script with extra tasks to run',
    :description => 'Script with extra tasks to run after deploy (relative path from target_path)',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/python/wsgi_apps/@/static_files_path",
    :display_name => 'Path to static files',
    :description => 'Path to static files (relative from target_path). Can be empty',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/python/wsgi_apps/@/timeout",
    :display_name => 'Request execution timeout',
    :description => 'Max execution time for requests (in seconds)',
    :default => 120,
    :validations => {predefined: "int"}

attribute "app/python/wsgi_apps/@/purge_target_path",
    :display_name => "Delete target_path folder before deploy",
    :description => "Delete 'target_path' folder before download application code",
    :default => 'no',
    :choice => ['yes','no']

 attribute "app/python/wsgi_apps/@/repo_depth",
    :display_name => "Number of past revisions to download (git)",
    :description => "The number of past revisions that will be included in the git shallow clone. The default behavior will do a full clone.",
    :default => 0,
    :validations => {predefined: "int"}
