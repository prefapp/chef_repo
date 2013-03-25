## configuracions especificas da instalacion de redmine con mysql

# 1) supoñemos que a runlist ten que levar a instalacion do servidor mysql
# nalgun lado (nos vamos a contar con que temos dispoñible o atributo

gem_package "mysql2"


mysql_connection_info = {
  :host =>  node['redmine']['database']['hostname'],
  :username => "root",
  :password => node['mysql']['server_root_password']
}

mysql_database node['redmine']['database']['name'] do
    connection mysql_connection_info
    action :create
end

#mysql_database "changing the charset of database" do
#  connection mysql_connection_info
#  database_name node['redmine']['database']['name']
#  action :query
#  sql "ALTER DATABASE #{node['redmine']['database']['name']} charset=latin1"
#end

node.set_unless['redmine']['database']['password'] = secure_password

mysql_database_user node['redmine']['database']['username'] do
  connection mysql_connection_info
  password node['redmine']['database']['password']
  action :create
end

mysql_database_user node['redmine']['database']['username'] do
  connection mysql_connection_info
  database_name node['redmine']['database']['name']
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
