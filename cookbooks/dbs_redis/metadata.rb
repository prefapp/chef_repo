maintainer       "RIYIC"
maintainer_email "info@riyic.com"
license          "Apache 2.0"
description      "Installs/Configures mysql client/server"
version          "0.0.1"
name             "dbsystem_mysql"

%w{debian ubuntu}.each do |os|
  supports os
end

depends "mysql"
depends "database"

# recetas
recipe  "default", 
    :description =>  "Install mysql client",
    :attributes => [] 

recipe  "server", 
    :description => "Install mysql server",
    :attributes =>  [/\/server\//, /\/tunable\//],
    :dependencies =>  []

recipe "create_db",
    :description => "Create a mysql db with its corresponding user",
    :attributes => [/\/dbs\//],
    :dependencies => ["dbsystem_mysql::server"],
    :stackable => true


### 
# ATRIBUTOS
### 
# atributos principales
attribute "dbsystem/mysql/server/root_password",
  :display_name => "MySQL Server Root Password",
  :description => "Password for the mysqld root user",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {predefined: "mysql_dbpassword"}

attribute "dbsystem/mysql/server/repl_password",
  :display_name => "MySQL Server Replication Password",
  :description => "Password for the mysql replication",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {predefined: "mysql_dbpassword"}

attribute "dbsystem/mysql/server/debian_password",
  :display_name => "MySQL Server Admin password for Debian",
  :description => "Password for the mysqld admin user in Debian",
  :advanced => false,
  :required => true,
  :calculated => true,
  :validations => {predefined: "mysql_dbpassword"}

attribute "dbsystem/mysql/server/bind_address",
  :display_name => "MySQL Bind Address",
  :description => "Address that mysqld should listen on",
  :default => "0.0.0.0",
  :validations => {predefined: "ipv4"}

# atributos para a receta de create_db
attribute "dbsystem/mysql/dbs/@/name",
    :display_name => "Database name",
    :description => "Database Name",
    :default => "my_db",
    :advanced => false,
    :required => true,
    :validations => {predefined: "mysql_dbname"}

attribute "dbsystem/mysql/dbs/@/user",
    :display_name => "Database username",
    :description => "Database related user",
    :default => "my_user",
    :advanced => false,
    :required => true,
    :validations => {predefined: "mysql_dbuser"}

attribute "dbsystem/mysql/dbs/@/password",
    :display_name => "Database user password",
    :description => "Database user password",
    :default => "my_user_password",
    :advanced => false,
    :required => true,
    :validations => {predefined: "db_password"}


# atributos de tuneo do servidor
attribute "dbsystem/mysql/tunable/key_buffer",
  :display_name => "MySQL Tunable Key Buffer",
  :default => "250M",
  :validations => {regex: /\A\d+M\z/}

attribute "dbsystem/mysql/tunable/max_connections",
  :display_name => "MySQL Tunable Max Connections",
  :default => "500",
  :validations => {range: 100..10000}

attribute "dbsystem/mysql/tunable/wait_timeout",
  :display_name => "MySQL Tunable Wait Timeout",
  :default => "180",
  :validations => {range: 10..30000}

attribute "dbsystem/mysql/tunable/net_read_timeout",
  :display_name => "MySQL Tunable Net Read Timeout",
  :default => "30",
  :validations => {range: 10..10000}

attribute "dbsystem/mysql/tunable/net_write_timeout",
  :display_name => "MySQL Tunable Net Write Timeout",
  :default => "30",
  :validations => {range: 10..10000}


attribute "dbsystem/mysql/tunable/back_log",
  :display_name => "MySQL Tunable Back Log",
  :default => "128",
  :validations => {range: 10..30000}

attribute "dbsystem/mysql/tunable/table_cache",
  :display_name => "MySQL Tunable Table Cache for MySQL < 5.1.3",
  :default => "128",
  :validations => {range: 16..65536}

attribute "dbsystem/mysql/tunable/table_open_cache",
  :display_name => "MySQL Tunable Table Cache for MySQL >= 5.1.3",
  :default => "128",
  :validations => {range: 16..65536}

attribute "dbsystem/mysql/tunable/max_heap_table_size",
  :display_name => "MySQL Tunable Max Heap Table Size",
  :default => "32M",
  :validations => {regex: /\A\d+M\z/}


attribute "dbsystem/mysql/tunable/expire_logs_days",
  :display_name => "MySQL Expire Log Days",
  :default => "10",
  :validations => {range: 1..365}

attribute "dbsystem/mysql/tunable/max_binlog_size",
  :display_name => "MySQL Max Binlog Size",
  :default => "100M",
  :validations => {regex: /\A\d+M\z/}


