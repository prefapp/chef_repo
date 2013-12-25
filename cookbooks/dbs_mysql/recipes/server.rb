# instalamos primeiro o cliente
include_recipe "dbs_mysql::default"

# seteamos os atributos da receta mysql::server
node["dbs"]["mysql"]["tunable"].each do |attribute, value|
    node.set["mysql"]["tunable"][attribute] = value
end

(%w{
    root_password 
    repl_password 
    debian_password 
    }).each do |attribute|

    node.set["mysql"]["server_#{attribute}"] = node["dbs"]["mysql"]["server"][attribute]
end

node.set["mysql"]["bind_address"] = node["dbs"]["mysql"]["server"]["bind_address"]

# incluimos a receta de instalacion do mysql server
include_recipe "mysql::server"

if node["riyic"]["dockerized"] == "yes"

    # evitamos cascar no script que setea os grants para debian
    # porque non vai a estar correndo o servicio
    ex = resources(execute: "install-grants")
    ex.command "/bin/true"

    # evitamos arrancar o servicio co upstart
    srv = resources(service: "mysql")
    srv.start_command "/bin/true"
    srv.stop_command "/bin/true"
    srv.restart_command "/bin/true"
    srv.action :nothing

    include_recipe "pcs_supervisor::default"

    supervisor_service "mysql_server" do        
        stdout_logfile "/var/log/supervisor/mysql_server.log"
        stderr_logfile "/var/log/supervisor/mysql_server.err"
        command "mysqld"
        startsecs 10
        stopsignal "QUIT"
        stopasgroup true
        killasgroup true
        # action [:enable,:start]
        action [:enable]
    end

    supervisor_service "mysql_server" do        
        stdout_logfile "/var/log/supervisor/mysql_server.log"
        stderr_logfile "/var/log/supervisor/mysql_server.err"
        command "mysqld"
        startsecs 10
        stopsignal "QUIT"
        stopasgroup true
        killasgroup true
        action [:start]
    end
end