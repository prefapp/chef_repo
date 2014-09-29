maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures postgresql client/server"
version          "0.1.0"
name             "dbs_postgresql"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "postgresql"
depends "database"

# recetas
recipe  "default", 
    :description =>  "Install postgresql client",
    :attributes =>  []

recipe  "server", 
    :description => "Install postgresql server",
    :attributes =>  [/\/server\//, /\/tunable\//]


recipe "create_db",
    :description => "Create a postgresql db with its corresponding user",
    :attributes => [/\/dbs\//],
    :dependencies => ["dbs_postgresql::server"],
    :stackable => true


### 
# ATRIBUTOS
### 
# atributos principales

attribute "dbs/postgresql/server/postgres_password",
    :display_name => "Postgres password",
    :description => "Password for the main postgresql user",
    :advanced => false,
    :required => true,
    :calculated => true,
    :validations => {predefined: "db_password"}


# atributos para a receta de create_db
attribute "dbs/postgresql/dbs/@/name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "my_db",
    :advanced => false,
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "dbs/postgresql/dbs/@/user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "my_user",
    :advanced => false,
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "dbs/postgresql/dbs/@/password",
    :display_name => "Database user password",
    :description => "Database user password",
    :advanced => false,
    :required => true,
    :calculated => true,
    :validations => {predefined: "db_password"}