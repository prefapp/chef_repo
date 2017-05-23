name             "tools_certbot"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install letsencrypt certbot"
version          "0.1.0"

depends "apt"


%w{debian ubuntu}.each do |os|
  supports os
end

recipe "default",
    :description => "Install letsencrypt certbot",
    :attributes => [/.+/]

