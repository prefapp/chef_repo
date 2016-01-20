name             "pcs_supervisor"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
version          "0.1.0"
description      "Install/Configures supervisor process control system"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "supervisor"

recipe "default",
    :description => "Install supervisor process control system",
    :attributes => [/.+/]

    
#attribute "appserver/nginx/passenger/version",
#    :display_name => 'Passenger version',
#    :description => 'Passenger version to compile and install with nginx',
#    :default => '4.0.8', #'3.0.21',
#    :advanced => false,
#    :validations => {predefined: "version"}
