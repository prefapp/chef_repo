name             "appserver_uwsgi"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install uWSGI and extensions"
version          "0.2.1"

depends "lang_python"
depends "lang_perl"
depends "build-essential"
depends "code_repo"

%w{debian ubuntu}.each do |os|
  supports os
end

# recipe "default",
#     description: "Installs uWSGI",
#     attributes: [/.+/],
#     dependencies: []

recipe "psgi",
    description: "Installs uWSGI with psgi support",
    attributes: [/.+/],
    dependencies: ["lang_perl::default"]

recipe "python",
    description: "Installs uWSGI with python support",
    attributes: [/^(?!.*\/(psgi)\/).*$/],
    dependencies: ["lang_python::default"]

## Atributos

# attribute "appserver/uwsgi/standalone",
#     :display_name => 'Compile a standalone binary?',
#     :description => 'Compile a standalone binary (without plugins)?',
#     :default => "yes",
#     :choice => ["yes","no"],
#     :required => true

attribute "appserver/uwsgi/url",
    :display_name => 'Source code URL',
    :description => 'URL to download the uwsgi source code package',
    :default => "http://projects.unbit.it/downloads/",
    :required => true,
    :validations => {predefined: "url"}


attribute "appserver/uwsgi/version",
    :display_name => 'uWSGI version',
    :description => 'uWSGI version to install',
    :default => "lts",
    :required => true,
    :advanced => false,
    :validations => {regex: /^(latest|lts|\d+\.\d+\.\d+)$/}

attribute "appserver/uwsgi/installation_path",
    :display_name => 'uWSGI installation path',
    :description => 'Directory where download and compile uwsgi',
    :default => "/opt/uwsgi",
    :required => true,
    :advanced => false,
    :validations => {predefined: "unix_path"}

attribute "appserver/uwsgi/socket",
    :display_name => 'Socket address where bind uwsgi',
    :description => 'Socket address where bind uwsgi',
    :default => "unix:///tmp/uwsgi.sock",
    :validations => {predefined: "socket_address"}

attribute "appserver/uwsgi/user",
    :display_name => 'uwsgi user',
    :default => 'www-data',
    :description => 'User who runs uwsgi',
    :validations => {predefined: "username"}

attribute "appserver/uwsgi/group",
    :display_name => 'uwsgi user group',
    :default => 'www-data',
    :description => 'User group who runs uwsgi',
    :validations => {predefined: "username"}


attribute "appserver/uwsgi/processes",
    :display_name => 'Default number of uwsgi processes to start',
    :description => 'Default number of uwsgi processes to start',
    :validations => {predefined: "int"}

attribute "appserver/uwsgi/threads",
    :display_name => 'Default number of uwsgi threads to start',
    :description => 'Default number of uwsgi threads to start',
    :validations => {predefined: "int"}


attribute "appserver/uwsgi/psgi/coroae",
    :display_name => 'Default number of coroutines to start',
    :description => 'Coro::AnyEvent coroutines to start at application run',
    :validations => {predefined: "int"}
    

attribute "appserver/uwsgi/extra_plugins",
    :display_name => 'Extra plugins to compile',
    :description => 'Extra plugins to compile to expand uwsgi functionality',
    :type => "array",
    :validations => {predefined: "word"}


attribute "appserver/uwsgi/run_options",
    :display_name => 'uWSGI run options',
    :description => 'Options to run uwsgi',
    :type => "hash",
    :validations => {predefined: "command_line_option"}
