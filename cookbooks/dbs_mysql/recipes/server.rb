# instalamos primeiro o cliente
include_recipe "dbs_mysql::default"

# seteamos os atributos da receta mysql::server
Hash(node["dbs"]["mysql"]["tunable"]).each do |attribute, value|
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

# mysql e un pouco especial para controlar co runit
# en vez dun command temos que pasarlle o script enteiro
node.set['container_service']['mysql']['run_script_content'] = <<EOF
#!/bin/sh
cd /
umask 077

MYSQLADMIN='/usr/bin/mysqladmin --defaults-extra-file=/etc/mysql/debian.cnf'

trap "$MYSQLADMIN shutdown" 0
trap 'exit 2' 1 2 3 15

/usr/bin/mysqld_safe --user=mysql & wait

EOF

# mais un script para chequear que esta levantado
node.set['container_service']['mysql']['check_script_content'] = <<EOF
#!/bin/sh
test -e /var/run/mysqld/mysqld.sock
EOF


# apparmor non se usa en containers pero para poder quitalo temos que facer
# un monton de cousas
node.set['container_service']['apparmor']['command'] = "sleep 100"
node.set['container_service']['apparmor']['disable'] = true
node.set['container_service']['apparmor-mysql']['command'] = "sleep 100"
node.set['container_service']['apparmor-mysql']['disable'] = true

## incluimos a receta de instalacion do mysql server
include_recipe "mysql::server"

# extra_tasks para o arranque do container
if node["riyic"]["inside_container"]
    
    file "#{node['riyic']['extra_tasks_dir']}/dbs_mysql-server.sh" do
        mode '0700'
        owner 'root'
        group 'root'
        content "chown -R mysql:mysql /var/lib/mysql"
    end    

end

# deshabilitamos e paramos o servicio fake apparmor 
#node.set['container_service']['apparmor-mysql2']['command'] = "sleep 100"
#
#service 'apparmor-mysql2' do
#    service_name 'apparmor'
#    action :stop
#    supports :stop => true
#end

#node.set['container_service']['default :create mysql']['command'] = 'aa'
#node.set['container_service']['default :create apparmor']['command'] = 'aa'
#
#mysql_service 'no_runit_mysql' do
#    initial_root_password   node['dbs']['mysql']['server']['root_password']
#    action                  [:create, :start]
#    bind_address            node['dbs']['mysql']['server']['bind_address']
#end

