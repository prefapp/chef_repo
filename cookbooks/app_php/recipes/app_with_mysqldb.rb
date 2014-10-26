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


##usamos os recursos 'mysql_database_user' e 'mysql_database' definido en database
# para crear o usuario e bbdd da applicacion se non existe xa
mysql_connection = {:host =>  node['app_php']['mysql']['db_host'],
                    :username => 'root',
                    :password => node['mysql']['server_root_password']
}

#creamos db
mysql_database node['app_php']['mysql']['db_name'] do
    connection mysql_connection
    action :create
end

#creamos user
mysql_database_user node['app_php']['mysql']['db_user'] do
    connection mysql_connection
    password node['app_php']['mysql']['db_password']
    action :create
end

#damoslle privilexions ao user sobre a bbdd
mysql_database_user node['app_php']['mysql']['db_user'] do
    connection mysql_connection
    action :grant
    database_name node['app_php']['mysql']['db_name']
    #privileges [] #por defecto todos
    #host '%' #por defecto localhost
end


## instalamos a aplicacion usando o LWRP 'application' de application
application node["app_php"]['domain'] do

    path node["app_php"]["dir"]
    owner node["apache"]["user"]
    group node["apache"]["group"]

    #usamos o repositorio e a revision que nos mande o usuario
    repository node["app_php"]["scm"]["repo"]
    revision node["app_php"]["scm"]["revision"]


    ## chamamos a o subrecursos php do cookbook application_php
    # para que faga o deploy da app, o cal solo define un par de metodos
    # a executar en before_compile: 
    # - instalar os paquetes pear que necesitemos
    # - generar o archivo de configuracion da app cos parametros remitidos en database
    
    db_name = node["app_php"]["mysql"]["db_name"]
    db_user = node["app_php"]["mysql"]["db_user"]
    db_password = node["app_php"]["mysql"]["db_password"]
    db_host = node["app_php"]["mysql"]["db_host"]

    ## se temos definido o atributo config_template, creamos o ficheiro de config
    unless node["app_php"]["config_template"] == ""
        php do
            #settings_template "#{local_settings_file}.erb"
            local_settings_file node["app_php"]["config_template"]

            database do

                Chef::Log.info("name #{db_name}, user #{db_user} ")
                database db_name
                user db_user
                password db_password
                host db_host
                
            end
        end
    end

    ## finalmente chamamos o subrecurso apache2_mod_php de application_php
    #  para que cree o virtual_host do apache
    mod_php_apache2 do
        server_aliases node["app_php"]["server_aliases"]
        webapp_template "php_vhost.conf.erb"
    end

end
