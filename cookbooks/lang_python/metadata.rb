name             "lang_python"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install python language from package or sources"
version          "0.1.1"

depends "python"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs python from package or sources",
    attributes: [/.+/],
    dependencies: []

attribute "lang/python/packages",
    :display_name => 'Packages to install',
    :description => 'List of python packages to install with pip',
    :type => "array",
    :default => [],
    # podese especificar a version con <nome>#<version>
    :validations => {predefined: "python_package" }
