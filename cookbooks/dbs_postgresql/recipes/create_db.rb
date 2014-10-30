# install postgresql-server
include_recipe "dbs_postgresql::server"

# to use 'postgresql_database' resource
include_recipe "database::postgresql"

# definimos a conexion
connection_info = {
  # :host =>  node['mysql']['server']['hostname'],
  :host => "localhost",
  :username => "postgres",
  :password => node['dbs']["postgresql"]["server"]['postgres_password']
}


# creamos todas as bbdd que deba ter o servidor
node['dbs']['postgresql']['dbs'].each do |db|
  postgresql_database db['name'] do
      connection connection_info
      action :create
  end

  postgresql_database_user db['user'] do
    connection connection_info
    password db['password']
    action :create
  end

  postgresql_database_user db['user'] do
    connection connection_info
    database_name db['name']
    password db['password']
    privileges [
      :all
    ]
    action :grant
  end

end