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

# queremos por defecto o charset das dbs que se creen a utf8
include_recipe "dbs_postgresql::_default_charset_utf8"


# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
    
    file "#{node['riyic']['extra_tasks_dir']}/dbs_postgresql-server.sh" do
        mode '0700'
        owner 'root'
        group 'root'
        content "chown -R postgres:postgres #{node['postgresql']['data_directory']}"
    end    

end
