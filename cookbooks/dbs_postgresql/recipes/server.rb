# set postgres password
node.set['postgresql']['password']['postgres'] = 
                                node["dbs"]["postgresql"]["server"]["postgres_password"]


# allow remote connections
if node["dbs"]["postgresql"]["server"]["allow_remote_connections"]

    node.set['postgresql']['config']['listen_addresses'] = '*'

end


include_recipe "postgresql::server"

include_recipe "dbs_postgresql::_default_charset_utf8"
