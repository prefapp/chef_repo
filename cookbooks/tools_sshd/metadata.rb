name             "tools_sshd"
maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Cookbook to install open ssh server"
version          "0.1.0"

%w{debian ubuntu}.each do |os|
  supports os
end
