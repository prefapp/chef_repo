# install mysql-server
include_recipe "dbs_mysql::server"

# to use 'mysql_database' resource
include_recipe "database::mysql"

# definimos a conexion
mysql_connection_info = {
  # :host =>  node['mysql']['server']['hostname'],
  :host => "localhost",
  :username => "root",
  :password => node['dbs']["mysql"]['server']['root_password']
}


# creamos todas as bbdd que deba ter o servidor mysql
node['dbs']['mysql']['dbs'].each do |db|
  mysql_database db['name'] do
      connection mysql_connection_info
      action :create
  end

  mysql_database_user db['user'] do
    connection mysql_connection_info
    password db['password']
    action :create
  end

  mysql_database_user db['user'] do
    connection mysql_connection_info
    database_name db['name']
    privileges [
      :all
    ]
    action :grant
  end

  mysql_database "flushing mysql privileges" do
    connection mysql_connection_info
    action :query
    sql "FLUSH PRIVILEGES"
  end
end