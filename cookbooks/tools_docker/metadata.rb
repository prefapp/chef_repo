name             "tools_docker"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install docker tools"
version          "0.1.0"

%w{debian ubuntu}.each do |os|
  supports os
end



recipe "compose",
    :description => "Install and manage docker-compose",
    :attributes => [/\/compose\//]

recipe "engine",
    :description => "Manage docker-engine",
    :attributes => [/\/engine\//]

recipe "machine",
    :description => "Manage docker-machine",
    :attributes => [/\/machine\//]


