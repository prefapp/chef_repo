name             "appserver_uwsgi"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install uWSGI and extensions"
version          "0.0.1"

depends "lang_python"
depends "lang_perl"
depends "build-essential"
depends "code_repo"
depends "pcs_supervisor"

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
    attributes: [/.+/],
    dependencies: []

## Atributos
# attribute "appserver/uwsgi/modules",
#     :display_name => 'Modules to compile',
#     :description => 'Modules to compile uWSGI with',
#     :default => ["python"],
#     :type => "array",
#     :validations => {regex: /^(python|psgi|lua|rack)$/},
#     :advanced => false

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
    :default => "1.9.18.2",
    :required => true,
    :validations => {predefined: "version"}

attribute "appserver/uwsgi/installation_path",
    :display_name => 'uWSGI installation path',
    :description => 'Directory where download and compile uwsgi',
    :default => "/opt/uwsgi",
    :required => true,
    :validations => {predefined: "unix_path"}

attribute "appserver/uwsgi/socket",
    :display_name => 'Socket address where bind uwsgi',
    :description => 'Socket address where bind uwsgi',
    :default => "unix:///tmp/uwsgi.sock",
    :required => true,
    :validations => {predefined: "socket_address"}

attribute "appserver/uwsgi/user",
    :display_name => 'uwsgi user',
    :description => 'User who runs uwsgi',
    :validations => {predefined: "username"}

attribute "appserver/uwsgi/group",
    :display_name => 'uwsgi user group',
    :description => 'User group who runs uwsgi',
    :validations => {predefined: "username"}


attribute "appserver/uwsgi/run_options",
    :display_name => 'uWSGI run options',
    :description => 'Options to run uwsgi',
    :type => "hash",
    :validations => {predefined: "command_line_option"}


