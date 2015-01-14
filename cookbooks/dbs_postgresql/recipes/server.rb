# set postgres password
node.set['postgresql']['password']['postgres'] = 
                                node["dbs"]["postgresql"]["server"]["postgres_password"]


# allow remote connections
if node["dbs"]["postgresql"]["server"]["allow_remote_connections"]

    node.set['postgresql']['config']['listen_addresses'] = '*'

end

# para arrancar o servicio co runit dentro dun container
node.set['container_service']['postgresql']['command'] = <<EOH
su -c '/usr/lib/postgresql/#{node['postgresql']['version']}/bin/postgres \\
      -D #{node['postgresql']['config']['data_directory']} \\
      -c config_file=#{node['postgresql']['dir']}/postgresql.conf' \\
- postgres
EOH

include_recipe "postgresql::server"

include_recipe "dbs_postgresql::_default_charset_utf8"
