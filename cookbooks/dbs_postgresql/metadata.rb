maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures postgresql client/server"
version          "0.1.2"
name             "dbs_postgresql"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "postgresql", "~> 3.4"
depends "database", "~> 2.3"

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


recipe "user_extra_privileges",
    :description => "Set extra privileges to user role",
    :attributes => [/\/user_extra_options\//],
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

attribute "dbs/postgresql/server/allow_remote_connections",
    :display_name => "Allow remote connections",
    :description => "Configure server to listen in all interfaces instead in localhost only",
    :advanced => false,
    :default => "no",
    :choice => ["yes","no"]

# atributos para a receta de create_db
attribute "dbs/postgresql/dbs/@/name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "my_db",
    :advanced => false,
    :required => true,
    :validations => {predefined: "postgresql_identifier"}

attribute "dbs/postgresql/dbs/@/user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "my_user",
    :advanced => false,
    :required => true,
    :validations => {predefined: "postgresql_identifier"}

attribute "dbs/postgresql/dbs/@/password",
    :display_name => "Database user password",
    :description => "Database user password",
    :advanced => false,
    :required => true,
    :calculated => true,
    :validations => {predefined: "db_password"}

# atributos para a recete user_extra_privileges
attribute "dbs/postgresql/user_extra_options/@/user",
    :display_name => "Database user",
    :description => "Database user to apply extra options",
    :advanced => false,
    :required => true,
    :default => 'user to apply extra privileges',
    :calculated => false,
    :validations => {predefined: "postgresql_identifier"}

attribute "dbs/postgresql/user_extra_options/@/extra_privileges",
    :display_name => "User extra privileges",
    :description => "List of user extra privileges",
    :advanced => false,
    :type => "array",
    :required => true,
    :default => ["list of extra privileges like CREATEDB"],
    :validations => {predefined: "postgresql_extra_privileges"}


attribute "dbs/postgresql/user_extra_options/@/allow_remote_connections",
    :display_name => "Allow remote connections",
    :description => "Allow or not remote connections with user",
    :advanced => false,
    :default => "no",
    :choice => ["yes","no"]
