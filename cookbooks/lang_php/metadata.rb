name             "lang_php"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install php language from package or sources"
version          "0.0.1"

depends "php"

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Installs php lang from package manager or sources",
    attributes: [/.+/],
    dependencies: []

