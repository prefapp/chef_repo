if node['dbs']['redis']['version'] == 'package'
    include_recipe 'dbs_redis::package'
else
    include_recipe 'dbs_redis::source'
end

service 'redis' do
  action [:enable, :start]
end


