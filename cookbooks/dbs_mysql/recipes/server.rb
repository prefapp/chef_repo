# instalamos primeiro o cliente
include_recipe "dbsystem_mysql::default"

# seteamos os atributos da receta mysql::server
node["dbsystem"]["mysql"]["tunable"].each do |attribute, value|
    node.set["mysql"]["tunable"][attribute] = value
end

(%w{
    root_password 
    repl_password 
    debian_password 
    }).each do |attribute|

    node.set["mysql"]["server_#{attribute}"] = node["dbsystem"]["mysql"]["server"][attribute]
end

node.set["mysql"]["bind_address"] = node["dbsystem"]["mysql"]["server"]["bind_address"]

# incluimos a receta de instalacion do mysql server
include_recipe "mysql::server"
