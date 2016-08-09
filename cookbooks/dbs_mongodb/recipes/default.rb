node.set['mongodb']['install_method'] = 'mongodb-org'
node.set['mongodb']['config']['bind_ip'] = node['dbs']['mongodb']['bind_address']

command = 'chpst -u mongodb:daemon /usr/bin/mongod -f /etc/mongodb.conf'

if node['dbs']['mongodb']['small_files'] == 'yes'
  command << ' --smallfiles'
end

node.set['container_service']['mongodb']['command'] = command


include_recipe "mongodb::default"
