# Seria para usar de forma apilable, para poder facer o deploy de varias apps
node["app"]["python"]["wsgi_apps"].each do |app|

  #instalar paquetes de sistema necesarios
  Array(app["extra_packages"]).each do |pkg|

    package pkg do 
        action :nothing
    end.run_action(:install)

  end

  # descargamos o codigo da app
  # en funcion do tipo de repositorio
  include_recipe "code_repo::default"
  
  case app["repo_type"]
  when "git" 
    provider = Chef::Provider::CodeRepoGit

  when "subversion"
    provider = Chef::Provider::CodeRepoSvn

  when "remote_archive"
    provider = Chef::Provider::CodeRepoRemoteArchive
  else
    provider = Chef::Provider::CodeRepoGit
  end

  code_repo app["target_path"] do
    provider    provider
    action      "pull"
    owner       app["owner"]
    group       app["group"]
    url         app["repo_url"]
    revision    app["revision"]
    credential  app["credential"]
    depth       1
  end



  # variables de entorno
  env_hash = {}

  # instalamos a librerias que necesite a applicacion

  if app["requirements_file"]

    bash "requirements" do
      ##########################################################
      # instalamos como root
      # para instalar como usuario:
      # 1) necesitamos que usuario tenha shell e home
      # 2) necesitamos pasarlle o parametro --user a pip

      # user        app["owner"]
      # group       app["group"]
      #########################################################

      cwd         app["target_path"]
      environment env_hash
      code        %{pip install -r #{app["requirements_file"]}}
    end
  end

  # modulos que non estan no requirements
  Array(app["extra_modules"]).each do |p|
    (name,version) = p.split('#')

    python_pip name do
      version version if(version)
    end

  end


  # aplicamos a migracion
  if app["migrate"] == "yes"
    bash "migration_run" do
        user        app["owner"]
        group       app["group"]
        cwd         app["target_path"]
        environment env_hash
        code        app["migration_command"]
    end
  end


  # executamos script post deploy
  if app["postdeploy_script"]

    bash "postdeploy" do    
        user        app["owner"]
        group       app["group"]
        cwd         app["target_path"]
        code        %{#{app["target_path"]}/#{app["postdeploy_script"]}}
    end

  end


  # socket que usaremos para comunicar nginx con uwsgi
  mi_socket = "unix:///tmp/#{app["domain"]}.sock"

  # timeout das peticions
  timeout = app['timeout'] || 120

  # configuramos o backend
  uwsgi_python_site app["domain"] do
    app_dir       app["target_path"]
    entry_point   app["entry_point"] 
    socket        mi_socket
    uid           app["owner"]
    gid           app["group"]
    options       :harakiri => timeout

  end

  # configuramos o frontend
  nginx_uwsgi_site app["domain"] do
    #static_files_path   "#{app["target_path"]}/public"
    static_files_path   "#{app["target_path"]}/#{app["static_files_path"]}" if app["static_files_path"]
    uwsgi_socket        mi_socket
    protocol            'python'
    uwsgi_read_timeout  timeout
  end

end
