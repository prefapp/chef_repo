name             "app_perl"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to deploy perl psgi applications"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "lang_perl"
depends "appserver_nginx"
depends "appserver_uwsgi"
depends "code_repo"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "empty",
    attributes: []


recipe "psgi_app",
    description: "Deploy a psgi app from repository with nginx+uwsgi support",
    attributes: [/^app\/perl\/psgi_apps\//],
    dependencies: ["lang_perl::default", "appserver_nginx::default", "appserver_uwsgi::psgi"],
    stackable: true

attribute "app/perl/psgi_apps/@/domain",
    :display_name => 'Application domain',
    :description => 'Domain associated to app virtual host',
    :default => 'test.com',
    :advanced => false,
    :required => true,
    :validations => {predefined: "domain"}

attribute "app/perl/psgi_apps/@/environment",
   :display_name => 'Application environment',
   :description => 'Application Environment',
   :default => 'production',
   :required => true,
   :validations => {predefined: "word"}

attribute "app/perl/psgi_apps/@/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/owner/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/perl/psgi_apps/@/entry_point",
    :display_name => "Application entry point script",
    :description => 'Script to start the application',
    :default => 'app.psgi',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/perl/psgi_apps/@/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "app/perl/psgi_apps/@/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}


attribute "app/perl/psgi_apps/@/repo_url",
    :display_name => 'Repository source code url',
    :description => 'Repository url from which to download source code',
    :advanced => false,
    :required => true,
    :default => "http://my-repo-url.com",
    :validations => {predefined: "url"}


attribute "app/perl/psgi_apps/@/repo_type",
    :display_name => "Repository type",
    :description => 'Repository type from which to download application code',
    :default => 'git',
    :advanced => false,
    :choice => ["git", "subversion","remote_archive"]

attribute "app/perl/psgi_apps/@/revision",
    :display_name => 'Application Repository revision',
    :description => 'Application repository tag/branch/commit/archive_name to download',
    :default => "HEAD",
    :validations => {predefined: "revision"}

attribute "app/perl/psgi_apps/@/credential",
    :display_name => 'Repository remote user credential',
    :description => 'Application repository remote user credential',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}


attribute "app/perl/psgi_apps/@/migration_command",
    :display_name => 'Migration command',
    :description => 'Command to run to migrate application to current state',
    :default => "",
    :validations => {predefined: "unix_command"}

attribute "app/perl/psgi_apps/@/extra_modules",
    :display_name => 'Extra perl modules',
    :description => 'Extra perl modules needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "perl_module"}

attribute "app/perl/psgi_apps/@/extra_packages",
    :display_name => 'Extra system packages',
    :description => 'Extra system packages needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}


attribute "app/perl/psgi_apps/@/postdeploy_script",
    :display_name => 'Bash script with extra tasks to run',
    :description => 'Script with extra tasks to run after deploy (relative path from target_path)',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/perl/psgi_apps/@/timeout",
    :display_name => 'Request execution timeout',
    :description => 'Max execution time for requests (in seconds)',
    :default => 120,
    :validations => {predefined: "int"}

attribute "app/perl/psgi_apps/@/purge_target_path",
    :display_name => "Delete target_path folder before deploy",
    :description => "Delete 'target_path' folder before download application code",
    :default => 'no',
    :choice => ['yes','no']

 attribute "app/perl/psgi_apps/@/repo_depth",
    :display_name => "Number of past revisions to download (git)",
    :description => "The number of past revisions that will be included in the git shallow clone. The default behavior will do a full clone.",
    :default => 0,
    :validations => {predefined: "int"}
