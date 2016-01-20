bash "template1-charset-utf8" do
  user 'postgres'
  code <<-EOH

echo "update pg_database set datallowconn = TRUE where datname = 'template0'; update pg_database set datistemplate = FALSE where datname = 'template1'; drop database template1;
create database template1 with template = template0 encoding = 'UTF8';update pg_database set datistemplate = TRUE where datname = 'template1';update pg_database set datallowconn = FALSE where datname = 'template0';"| psql -p #{node['postgresql']['config']['port']}

  EOH
  action :run
end
