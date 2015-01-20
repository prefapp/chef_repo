name             "riyic"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage riyic configurations"
version          "0.2.6"

# riyic
depends 'system_cron'
depends "system_package"

# supermarket
depends 'chef_handler', '~> 1.1'
depends 'locale', '~> 1.0'
depends 'runit', '~> 1.5'

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Default riyic recipe",
    attributes: [/.+/],
    dependencies: []

## Atributos
attribute "riyic/dockerized",
    :display_name => 'Dockerized',
    :description => 'Is going to be this server dockerized?',
    :required => true,
    :default => "no",
    :choice => ["yes","no"],    
    :validations => {regex: /^(never)|\d+(min|h|d)?/},
    :advanced => false

## Atributos
attribute "riyic/system_locale",
    :display_name => 'System locale settings',
    :description => 'Default system locale for this system',
    :required => true,
    :default => "en_US.UTF-8",
    :validations => {regex: /^(C|POSIX|[a-z]{2,3}\_[a-z]{2})\.?[a-z0-9\-]{0,10}$/i },
    :advanced => false

attribute "riyic/updates_check_interval",
    :display_name => 'Updates check interval',
    :description => 'How often check for update with central server (1min,2h,3d)',
    :required => true,
    :default => "never",
    :validations => {regex: /^(never)|\d+(min|h|d)?/},
    :advanced => false
