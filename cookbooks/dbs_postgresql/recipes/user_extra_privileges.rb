connection_info = {
  :host => "localhost",
  :username => "postgres",
  :password => node['dbs']["postgresql"]["server"]['postgres_password']
}



node['dbs']['postgresql']['user_extra_options'].each do |item|

    bash "assign_extra_privileges" do

      user 'postgres'
      code <<-EOH

echo "ALTER ROLE #{item['user']} #{item['extra_privileges'].join(' ')};" | psql -p #{node['postgresql']['config']['port']}
      
EOH
      action :run

    end


    if item['allow_remote_connections'] == 'yes'

        node.override['postgresql']['pg_hba'] = node['postgresql']['pg_hba'] + [{
            # :comment => '# remote connections',
            :type => 'host', 
            :db => 'all', 
            :user => item['user'], 
            :addr => 'all', # item[remote_hosts] 
            :method => 'md5'
        }]

    end

end
