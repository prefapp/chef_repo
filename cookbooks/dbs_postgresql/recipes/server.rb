node.set['postgresql']['password']['postgres'] = node["dbs"]["postgresql"]["server"]["postgres_password"]
include_recipe "postgresql::server"
