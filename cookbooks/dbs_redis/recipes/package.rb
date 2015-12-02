package 'redis-server'

node.set['container_service']['redis']['command'] = 
 '/usr/bin/redis-server /etc/redis/redis.conf' # >> /var/log/redis.log 2>&1'
