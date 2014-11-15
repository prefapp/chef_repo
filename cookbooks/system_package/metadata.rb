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
    attributes: [%w(system/packages/list)],
    dependencies: []

recipe "custom_installation",
    description: "Packages custom installation",
    attributes: [/\/custom_installation\//],
    dependencies: [],
    stackable: true

# recipe "from_repo" 
# installs the list of packages from a repo
# first the repo is added to source list

## Atributos
attribute "system/packages/list",
    :display_name => 'List of system packages to install, with optional version',
    :description => 'List of system packages to install, with optional version. For example "apache2=2.2.20-1ubuntu1"',
    :required => true,
    :default => ["list of distribution packages to install"],
    :type => "array",
    :validations => {predefined: "package_name"},
    :advanced => false

attribute "system/packages/custom_installation/@/name",
    :display_name => 'Package name',
    :description => 'Name of the package to install',
    :required => true,
    :validations => {predefined: "package_name"},
    :default => "name of some package to install",
    :advanced => false

attribute "system/packages/custom_installation/@/source",
    :display_name => 'Package source file',
    :description => 'Package filesystem path',
    :required => false,
    :validations => {predefined: "unix_path"},
    :advanced => false

attribute "system/packages/custom_installation/@/source_url",
    :display_name => 'Package source url',
    :description => 'Url from which to download the package',
    :required => false,
    :validations => {predefined: "url"},
    :advanced => false

attribute "system/packages/custom_installation/@/checksum",
    :display_name => 'Package checksum',
    :description => 'Package checksum ',
    :required => false,
    :validations => {predefined: "checksum"},
    :advanced => false

attribute "system/packages/custom_installation/@/version",
    :display_name => 'Package version',
    :description => 'Package version',
    :required => false,
    :validations => {predefined: "version"},
    :advanced => true

attribute "system/packages/custom_installation/@/options",
    :display_name => 'Package installation options',
    :description => 'Package extra installation options',
    :required => false,
    :validations => {predefined: "command_line_option"},
    :advanced => true



