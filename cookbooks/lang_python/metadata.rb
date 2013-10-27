name             "lang_python"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install python language from package or sources"
version          "0.0.1"

depends "python"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs python from package and npm",
    attributes: [/.+/],
    dependencies: []

## Atributos
#attribute "lang/nodejs/version",
#    :display_name => 'Nodejs version (latest = last version, legacy = previous',
#    :description => 'Nodejs version to install',
#    :default => 'latest',
#    :validations => {regex: /^(latest|legacy|\d+\.\d+\.\d+)$/},
#    :advanced => false

