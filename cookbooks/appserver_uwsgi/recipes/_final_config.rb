## creamos un link en /usr/local/bin
link "/usr/local/bin/uwsgi" do
  to "#{node["appserver"]["uwsgi"]["installation_path"]}/uwsgi"
end

# configuramos os parametros de arranque para o supervisor
# template "/etc/uwsgi.ini" do
#   source "uwsgi.ini.erb"
#   owner
#   group
#   mode 
#   variables(:options => node["appserver"]["uwsgi"]["run_options"])
# end

uid = node["appserver"]["uwsgi"]["user"] || "www-data"
gid = node["appserver"]["uwsgi"]["group"] || "www-data"

run_options = {}
run_options["socket"] = node["appserver"]["uwsgi"]["socket"] 
run_options["master"] = ""
# run_options["daemonize"] = log_file
run_options["uid"] = uid
run_options["gid"] = gid
run_options["chmod-socket"] = "666"

run_options["harakiri"] = node["appserver"]["uwsgi"]["harakiri"] if node["appserver"]["uwsgi"]["harakiri"]


# mergeamos cas opcions avanzadas pasadas polo parametro run_options
run_options.merge!(node["appserver"]["uwsgi"]["run_options"])

# mergeamos cas opcions que introduzca o modulo concreto
# que teran preferencia sobre as demais
run_options.merge!(node.run_state["uwsgi_run_options"])

# construimos o comando que lance o uwsgi (tamen se poderia facer un ficheiro ini)
command = "/usr/local/bin/uwsgi"
run_options.each do |k,v|
  command << " --#{k}"
  command << "=#{v}" unless v==""
end


Chef::Log.info("#{command}")
# a ver se damos pasado a app desde o nginx
# command << " #{node["appserver"]["uwsgi"]["wsgi_app"]}"

# instalamos o supervisord e configuramos o control do uwsgi
include_recipe "pcs_supervisor::default"

supervisor_service "uwsgi" do        
    stdout_logfile "/var/log/supervisor/uwsgi.log"
    stderr_logfile "/var/log/supervisor/uwsgi.err"
    command command
    startsecs 10
    stopsignal "QUIT"
    stopasgroup true
    killasgroup true
    action "enable"
end