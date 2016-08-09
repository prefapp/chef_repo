maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures mongodb client/server"
version          "0.1.4"
name             "dbs_mongodb"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "mongodb",'~> 0.16'

# recetas
recipe  "default",
  :description =>  "Install mongodb server",
  :attributes =>  [/.+/],
  :dependencies =>  []


###
# ATRIBUTOS
###
# atributos principales

attribute "dbs/mongodb/bind_address",
  :display_name => 'Bind address',
  :description => 'Ip address to bind service to',
  :default => '127.0.0.1',
  :advanced => false,
  :validations => {predefined: "ipv4"}


attribute "dbs/mongodb/small_files",
  :display_name => 'Small files',
  :description => 'Enable flag small_files to reduce size of data files and journal',
  :default => 'yes',
  :advanced => false,
  :choice => ['yes','no']
