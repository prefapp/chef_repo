# instalamos os nosos handlers
include_recipe "riyic::_riyic_handlers"

## habilitamos o handler de riyic::report para que comunique a webapp o estado de convergencia do nodo
chef_handler "Riyic::Report" do
  #source "chef/handler/riyic_report.rb"
  source "#{node["chef_handler"]["handler_path"]}/riyic_report.rb"

  arguments :auth_token => node['riyic']['key'], 
            :server_id => node['riyic']['server_id'],
            :env => node['riyic']['env']

  action :nothing
  
end.run_action(:enable)

#
# outros arreglos necesarios para evitar problemas
#

# seteamos por defecto a codificacion a UTF8
# Esta sera a codificacion ca que se crean string desde un template ou un ficheiro externo
# sen esto un template con caracteres utf8 casca

# configuramos as locales (senon vai a dar problemas a execucion de algunha receta de chef)
include_recipe "riyic::_configure_locale"

# - Se algunha receta usa build_essential, que se instale o principio da fase de compilacion
# para que outra receta que use a fase de compilacion que xa disponha das ferramentas

node.set['build-essential']['compile_time'] = true


# - Actualizamos a cache de apt, por si alguen quere instalar algun paquete na fase de compilacion
#  tendo en conta que pode que se actualizara a cache do apt no ultimo dia

include_recipe "system_package::update_cache"

# Se estamos en docker instalamos runit
# para usalo como init
if node['virtualization']['system'] =~ /^lxc|docker$/

    # flag para outros cookbooks
    node.set["riyic"]["inside_container"] = true

    include_recipe "runit::default"

    # arrancamos o servicio de runit en segundo plano
    # para conseguir executar a converxencia do nodo
    execute 'start-runsvdir' do
        command "/usr/bin/runsvdir -P /etc/service 'log: #{ '.' * 395}' &"
        action  :run
        not_if  "ps -auxwwwf| fgrep -v fgrep | fgrep runsvdir"
    end
end


# creamos unha tarea cron para
# executar o cliente de riyic periodicamente si se habilitou a opcion
#
#if node["riyic"]["updates_check_interval"] && node["riyic"]["updates_check_interval"] != "never"
#
#    raise "mecagoen :#{node["riyic"]["updates_check_interval"]}"
#
#    include_recipe "system_cron::default"
#
#    interval = node["riyic"]["updates_check_interval"]
#    (min,hour,day,month,weekday) = %w{* * * * *}
#
#    if interval =~ /^(\d+)(min)?$/
#      min = "*/#{$1}"
#    elsif interval =~ /^(\d+)h$/
#      hour = "*/#{$1}"
#    elsif interval =~ /^(\d+)d$/
#      day = "*/#{$1}"
#    end
#
#    cron_d "riyic_update_task" do
#        minute  min
#        hour    hour
#        day     day
#        month   month
#        weekday weekday
#        command "/usr/sbin/ryc -A #{node['riyic']['key']} -S #{node['riyic']['server_id']} -E #{node['riyic']['env']} 2>&1 >/dev/null"
#        user    "root"
#    end
#  
#end
