name             "appserver_fpm"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install and configure php-fpm service"
version          "0.2.2"

#depends "php-fpm"
depends "php5-fpm", '~> 0.4'

%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    description: "Install php-fpm from package manager and initialize default 'www' pool",
    attributes: [/.+/],
    dependencies: []
