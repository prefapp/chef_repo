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
recipe  "default", 
    description: "Install mysql client",
    #attributes: ["!apache/allowed_openids","!apache/ext_status"]
    #como se poden seleccionar estos modulos desde a receta principal, haber que permitirlle as opcions na receta ppal
    attributes: [] 

recipe  "server", 
    description: "Install mysql server",
    attributes: [/server.+/, "mysql/bind_address"]

#recipe "logrotate",
#    description: "Rotate apache logs. Requires logrotate cookbook",
#    dependencies: ["logrotate:default"]


### 
# ATRIBUTOS
### 
# atributos principales
attribute "mysql/server_root_password",
  :display_name => "MySQL Server Root Password",
  :description => "Password for the mysqld root user",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {regex: /\A[\w\.\-]+\z/}

attribute "mysql/server_repl_password",
  :display_name => "MySQL Server Replication Password",
  :description => "Password for the mysql replication",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {regex: /\A[\w\.\-]+\z/}

attribute "mysql/server_debian_password",
  :display_name => "MySQL Server Admin password for Debian",
  :description => "Password for the mysqld admin user in Debian",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {regex: /\A[\w\.\-]+\z/}

attribute "mysql/bind_address",
  :display_name => "MySQL Bind Address",
  :description => "Address that mysqld should listen on",
  :default => "127.0.0.1",
  :advanced => true,
  :validations => {regex: /\A\d+\.\d+\.\d+\.\d+\z/}



