name             "riyic"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage riyic configurations"
version          "0.1.0"

depends "system_cron"
depends "chef_handler"

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
    :advanced => false

attribute "riyic/updates_check_interval",
    :display_name => 'Updates check interval',
    :description => 'How often check for update with central server (1min,2h,3d)',
    :required => true,
    :default => "never",
    :validations => {regex: /^(never)|\d+(min|h|d)?/},
    :advanced => false
