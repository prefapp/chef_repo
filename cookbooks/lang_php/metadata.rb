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

attribute "lang/php/version",
   :display_name => "php version to install ",
   :description => 'PHP version to install',
   :default => '5.5',
   :choice => %w{5.5 5.6 7.0 7.1},
   :advanced => false
