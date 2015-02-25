node.set['mongodb']['install_method'] = 'mongodb-org'
node.set['mongodb']['config']['bind_ip'] = node['dbs']['mongodb']['bind_address']

node.set['container_service']['mongodb']['command'] = 
    'chpst -u mongodb:daemon /usr/bin/mongod -f /etc/mongodb.conf'

include_recipe "mongodb::default"

