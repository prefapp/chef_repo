# params permitidos
# :name => nome da aplicacion
# :app_dir => directorio root de la aplicacion
# :entry_point => script de acceso a la app psgi(app.psgi por defecto)
# :uid => usuario con que correr uwsgi, se non se pasa pillase o definido en appserver/uwsgi/user 
# :gid => grupo con que correr uwsgi, se non se pasa pillase o definido en appserver/uwsgi/group
# :socket => socket en donde lanzar o uwsgi, se non se pasa usaremos o definido en  appserver/uwsgi/socket
# :processes => numero de procesos uwsgi a lanzar para atender a app, senon se pasa pillamos appserver/uwsgi/processes
# :threads => numero de threads cos que lanzar uwsgi para atender a app, senon se pasa pillamos appserver/uwsgi/threads
# :coroae => numero de corutinas cas que lanzar o servidor, se e 0 ou non se pasa entendese que non se usara o plugin coroae
# :options => hash con outras opcions para pasar ao uwsgi

define :uwsgi_psgi_site,  :options => {} do

    app = params[:name]
    app_directory = params[:app_dir]
    entry_point = params[:entry_point] || 'app.psgi'

    uid = params[:uid] || node["appserver"]["uwsgi"]["user"]
    gid = params[:gid] || node["appserver"]["uwsgi"]["group"] 
    socket = params[:socket] || node["appserver"]["uwsgi"]["socket"]
    uwsgi_socket = socket.gsub(/^(unix|tcp|udp)?(\:\/\/)?/,'')

    # valor base n_cpus
    processes = params[:processes] || node["appserver"]["uwsgi"]["processes"]

    # para python os threads non funcionan moi ben, e en perl non creo que vaian moito mellor
    threads = params[:threads] || node["appserver"]["uwsgi"]["threads"]

    # coro::anyevent coroutines, por defecto a menos que se pasen explicitamente non as usamos
    coroae = params[:coroae] || node["appserver"]["uwsgi"]["psgi"]["coroae"]


    # aseguramonos que se instale o uwsgi co plugin psgi e coroae
    include_recipe "appserver_uwsgi::psgi"

    run_options = {}
    run_options["socket"] = uwsgi_socket
    run_options["plugins-dir"] = node["appserver"]["uwsgi"]["installation_path"]
    run_options["plugin"] = "psgi"
    run_options["plugin"] << ',coroae' if coroae > 0

    run_options["processes"] = processes if processes > 0
    run_options["threads"] = threads if threads > 0
    run_options["coroae"] = coroae if coroae > 0

    run_options["perl-no-die-catch"] = ""
    run_options["chdir"] = app_directory
    run_options["psgi"] = entry_point

    run_options["master"] = ""
    # run_options["daemonize"] = params[:log_file]

    run_options["uid"] = uid
    run_options["gid"] = gid
    run_options["chmod-socket"] = "666"
    run_options["need-app"] = ""


    run_options.merge!(params[:options])
    # mergeamos cas opcions avanzadas pasadas polo parametro run_options
    # run_options.merge!(node["appserver"]["uwsgi"]["run_options"])

    # construimos o comando que lance o uwsgi (tamen se poderia facer un ficheiro ini)
    command = "/usr/local/bin/uwsgi"
    run_options.each do |k,v|
      command << " --#{k}"
      command << "=#{v}" unless v==""
    end

    Chef::Log.info("#{command}")

    # instalamos o supervisord e configuramos o control do uwsgi
    include_recipe "pcs_supervisor::default"

    supervisor_service "psgi-#{app}" do        
        stdout_logfile "/var/log/supervisor/psgi_#{app}.log"
        stderr_logfile "/var/log/supervisor/psgi_#{app}.err"
        command command
        startsecs 10
        stopsignal "QUIT"
        stopasgroup true
        killasgroup true
        action "enable"
    end
end