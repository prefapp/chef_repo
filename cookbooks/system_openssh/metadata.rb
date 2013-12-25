name             "system_openssh"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage openssh service"
version          "0.0.1"

depends "openssh"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs ssh service",
    attributes: [],
    dependencies: []

## Atributos
#attribute "system/cron/tasks/@/minute",
#    :display_name => 'Minute',
#    :description => 'Minute field in cron task',
#    :required => true,
#    :default => '*',
#    :validations => {regex: /^[*\/\d\-]+$/},
#    :advanced => false
