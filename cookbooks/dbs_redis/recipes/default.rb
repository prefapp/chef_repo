if node['dbs']['redis']['version'] == 'package'
    include_recipe 'dbs_redis::package'
else
    include_recipe 'dbs_redis::source'
end

node.set['container_service']['redis']['command'] = 
 '/usr/bin/redis-server /etc/redis/redis.conf' # >> /var/log/redis.log 2>&1'

service 'redis' do
  action: [:enable, :start]
end


