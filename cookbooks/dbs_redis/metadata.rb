maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures redis client/server"
version          "0.1.0"
name             "dbs_redis"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "code_repo"
depends "build-essential"

# recetas
recipe  "default", 
    :description =>  "Install redis server",
    :attributes =>  [/.+/],
    :dependencies =>  []


### 
# ATRIBUTOS
### 
# atributos principales

attribute "dbs/redis/version",
    :display_name => 'Redis version (x.x.x or stable = actual stable release) ',
    :description => 'Redis version to install',
    :default => '2.8.1',
    :validations => {regex: /^(stable|\d+\.\d+\.\d+)$/},
    :advanced => false

attribute "dbs/redis/force_recompile",
    :display_name => 'Recompile?',
    :description => 'If "yes" force recompile redis-server',
    :choice => ["yes","no"],
    :default => "no",
    :required => true

