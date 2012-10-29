maintainer       "RuleYourCloud"
maintainer_email "info@ruleyourcloud.com"
license          "All rights reserved"
description      "Installs/Configures mysql client/server"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end

# recetas
recipe  "dbserver_mysql", 
    description: "Install mysql client",
    #attributes: ["!apache/allowed_openids","!apache/ext_status"]
    #como se poden seleccionar estos modulos desde a receta principal, haber que permitirlle as opcions na receta ppal
    attributes: [] 

recipe  "server", 
    description: "Install mysql server"

#recipe "logrotate",
#    description: "Rotate apache logs. Requires logrotate cookbook",
#    dependencies: ["logrotate:default"]


### 
# ATRIBUTOS
### 
# atributos principales
attribute "apache/listen_ports",
  :display_name => "Apache Listen Ports",
  :description => "Ports that Apache should listen on",
  :advanced => false,
  :type => "array",
  :default => [ "80" ],
  :validations => {range: 1..65535}

attribute "apache/contact",

