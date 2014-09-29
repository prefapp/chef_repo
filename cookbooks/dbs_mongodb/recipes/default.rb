node.set['mongodb']['install_method'] = 'mongodb-org'
include_recipe "mongodb::default"

## creamos o script de arranque e arrancamos o servicio
# instalamos o supervisord e configuramos o control do uwsgi
# include_recipe "pcs_supervisor::default"

# service_name = "mongodb"
# supervisor_service service_name do        
#     stdout_logfile "/var/log/supervisor/#{service_name}.log"
#     stderr_logfile "/var/log/supervisor/#{service_name}.err"
#     command "mongod --config #{node['mongodb']['dbconfig_file']}"
#     startsecs 10
#     action "enable"
# end
