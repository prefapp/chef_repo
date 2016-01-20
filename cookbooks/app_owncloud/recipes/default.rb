include_recipe "app_php::default"
include_recipe "code_repo::default"

dbtype = node['app']['owncloud']['db_type']

if dbtype == 'mysql'
  include_recipe 'dbs_mysql::default'
elsif  dbtype == 'pgsql'
  include_recipe 'dbs_postgresql::default'
else
  Chef::Application.fatal!("#{dbtype} not supported yet")
end
