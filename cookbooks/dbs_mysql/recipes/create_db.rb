include_recipe "dbsystem_mysql::server"

# definimos a conexion
mysql_connection_info = {
  :host =>  node['mysql']['server']['hostname'],
  :username => "root",
  :password => node['mysql']['server']['root_password']
}


# creamos todas as bbdd que deba ter o servidor mysql
node['mysql']['server']['dbs'].each do |db|
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