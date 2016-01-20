maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures zeromq C bindings"
version          "0.0.1"
name             "mq_zeromq"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "code_repo"
depends "build-essential"


# recetas
recipe  "default", 
    :description =>  "Install zeromq C bindings",
    :attributes => [/.+/] 


### 
# ATRIBUTOS
### 
# atributos principales

attribute "mq/zeromq/version",
    :display_name => 'ZeroMQ version',
    :description => 'ZeroMQ version to install',
    :default => '4.0.3',
    :validations => {predefined: "version"},
    :advanced => false

attribute "mq/zeromq/force_recompile",
    :display_name => 'Recompile?',
    :description => 'If "yes" force recompile zeromq library',
    :choice => ["yes","no"],
    :default => "no",
    :required => true

