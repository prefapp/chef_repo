## receta para instalar o wordpress localmente
## depende de varios dos noso cookbooks:
#   - webserver_apache
##  - dbserver_mysql

## instalamos apache
include_recipe "webserver_apache"

## instalamos mysql (a menos q a bbdd vaia a estar en outra maquina)
include_recipe "dbserver_mysql::server"


## instalamos el paquete de git e subversion
# esto hai que metelo noutro lado
# forma parte do deploy de aplicacions
package "git-core"
package "subversion"

## fai falta o paquete de mysql para php
package "php5-mysql"


unless node['wordpress']['domain']
    node['wordpress']['domain'] = 'test.com'
end


##usamos os recursos 'mysql_database_user' e 'mysql_database' definido en database
# para crear o usuario e bbdd da applicacion se non existe xa
mysql_connection = {:host =>  node['wordpress']['db_host'],
                    :username => 'root',
                    :password => node['mysql']['server_root_password']
}

#creamos db
mysql_database node['wordpress']['db_name'] do
    connection mysql_connection
    action :create
end

#creamos user
mysql_database_user node['wordpress']['db_user'] do
    connection mysql_connection
    password node['wordpress']['db_password']
    action :create
end

#damoslle privilexions ao user sobre a bbdd
mysql_database_user node['wordpress']['db_user'] do
    connection mysql_connection
    action :grant
    database_name node['wordpress']['db_name']
    #privileges [] #por defecto todos
    #host '%' #por defecto localhost
end


## instalamos a aplicacion usando o LWRP 'application' de application
application node["wordpress"]['domain'] do

    path node["wordpress"]["dir"]
    owner node["apache"]["user"]
    group node["apache"]["group"]

    ## a ver q tal esto
    # tiramos directamente do repositorio de github
    # ca version stable (o ultimo commit asociado a tag 3.4.2)
    repository "https://github.com/WordPress/WordPress.git"
    revision "6dde3d91f23bff5ab81e91838f19f306b33fe7a8"

    ## chamamos a o subrecursos php do cookbook application_php
    # para que faga o deploy da app, o cal solo define un par de metodos
    # a executar en before_compile: 
    # - instalar os paquetes pear que necesitemos
    # - generar o archivo de configuracion da app cos parametros remitidos en database
    
    db_name = node["wordpress"]["db_name"]
    db_user = node["wordpress"]["db_user"]
    db_password = node["wordpress"]["db_password"]
    db_host = node["wordpress"]["db_host"]

    php do
        #settings_template "#{local_settings_file}.erb"
        local_settings_file "wp-config.php"

        database do

            Chef::Log.info("name #{db_name}, user #{db_user}, pass #{db_password} ")
            database db_name
            user db_user
            password db_password
            host db_host
            
            #database node["wordpress"]['db_name']
            #user node["wordpress"]['db_user']
            #password node['wordpress']['db_password']
            #host node['wordpress']['db_host']
        end
    end

    ## finalmente chamamos o subrecurso apache2_mod_php de application_php
    #  para que cree o virtual_host do apache
    mod_php_apache2 do
        #server_aliases []
        webapp_template "php_vhost.conf.erb"
    end

end
