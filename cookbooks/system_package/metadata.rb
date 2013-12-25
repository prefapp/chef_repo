name             "system_package"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to manage system packages"
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs system package list",
    attributes: [/.*/],
    dependencies: []

# recipe "from_repo" 
# installs the list of packages from a repo
# first the repo is added to source list

## Atributos
attribute "system/packages/list",
    :display_name => 'List of system packages to install, with optional version',
    :description => 'List of system packages to install',
    :required => true,
    :default => ["apache2=2.2.20-1ubuntu1"],
    :type => "array",
    :validations => {predefined: "package_name"},
    :advanced => false

