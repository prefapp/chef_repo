name             "app_nodejs"
maintainer       "prefapp"
maintainer_email "info@prefapp.com"
license          "All rights reserved"
description      "Cookbook for the deploy php apps"
version          "0.1.0"


depends "lang_nodejs"
depends "code_repo"
depends "riyic"

%w{debian ubuntu}.each do |os|
  supports os
end

#
#recetas
#

recipe "node_app",
    description: "Deploy a node app from remote repository",
    attributes: [/^app\/nodejs\//],
    stackable: false

#
# atributos
#

#attribute "app/nodejs/environment",
#    :display_name => 'Application environment',
#    :description => 'Application Environment',
#    :default => 'production',
#    :advanced => false,
#    :required => true,
#    :validations => {predefined: "word"}

attribute "app/nodejs/env_vars",
    :display_name => 'Application config vars from environment',
    :description => 'Application configuration variables passed through environment',
    :default => {},
    :type => "hash",
    :validations => {predefined: "text"}

attribute "app/nodejs/target_path",
    :display_name => "Application deployment folder",
    :description => 'The application will be deployed to this folder',
    :default => '/home/owner/my_app',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/nodejs/entry_point",
    :display_name => "Application entry point script",
    :description => 'Script to start the application',
    :default => 'index.js',
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "app/nodejs/owner",
    :display_name => "Deployment owner",
    :description => 'User that shall own the target path',
    :default => 'owner',
    :advanced => false,
    :validations => {predefined: "username"}

attribute "app/nodejs/group",
    :display_name => "Deployment group",
    :description => 'The group that shall own the target path',
    :default => 'ownergrp',
    :validations => {predefined: "username"}


attribute "app/nodejs/repo_url",
    :display_name => 'Repository source code url',
    :description => 'Repository url from which to download source code',
    :advanced => false,
    :required => true,
    :default => "http://my-repo-url.com",
    :validations => {predefined: "url"}


attribute "app/nodejs/repo_type",
    :display_name => "Repository type",
    :description => 'Repository type from which to download application code',
    :default => 'git',
    :advanced => false,
    :choice => ["git", "subversion","remote_archive"]

attribute "app/nodejs/revision",
    :display_name => 'Application Repository revision',
    :description => 'Application repository tag/branch/commit/archive_name to download',
    :default => "HEAD",
    :validations => {predefined: "revision"}


attribute "app/nodejs/credential",
    :display_name => 'Repository remote user credential',
    :description => 'Application repository remote user credential',
    :field_type => 'textarea',
    :validations => {predefined: "multiline_text"}


attribute "app/nodejs/migration_command",
    :display_name => 'Migration command',
    :description => 'Command to run to migrate application to current state',
    :default => "",
    :validations => {predefined: "unix_command"}

attribute "app/nodejs/extra_modules",
    :display_name => 'Extra npm modules needed',
    :description => 'Extra npm modules needed by the application, globally',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}

attribute "app/nodejs/extra_packages",
    :display_name => 'Extra system packages',
    :description => 'Extra system packages needed by the application',
    :type => "array",
    :default => [],
    :validations => {predefined: "package_name"}


attribute "app/nodejs/postdeploy_script",
    :display_name => 'Bash script with extra tasks to run',
    :description => 'Script with extra tasks to run after deploy (relative path from target_path)',
    :default => "",
    :validations => {predefined: "unix_path"}

attribute "app/nodejs/purge_target_path",
    :display_name => "Delete target_path folder before deploy",
    :description => "Delete 'target_path' folder before download application code",
    :default => 'no',
    :choice => ['yes', 'no']

 attribute "app/nodejs/repo_depth",
    :display_name => "Number of past revisions to download (git)",
    :description => "The number of past revisions that will be included in the git shallow clone. The default behavior will do a full clone.",
    :default => '0',
    :validations => {predefined: "int"}
