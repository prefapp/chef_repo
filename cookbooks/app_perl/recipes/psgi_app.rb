# Seria para usar de forma apilable, para poder facer o deploy de varias apps
node["app"]["perl"]["psgi_apps"].each do |app|

  #instalar paquetes de sistema necesarios
  if app["extra_packages"]
      app["extra_packages"].each do |pkg|
        package pkg
      end
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
  end



  # variables de entorno
  env_hash = {
  }

  # instalamos a librerias que necesite a applicacion
  if app["extra_modules"] and app["extra_modules"].size > 0 
    perlenv_cpanm 'install_extra_modules' do
        modules app["extra_modules"]
    end
  end


  # aplicamos a migracion
  if app["migrate"] == "yes"
    perlenv_shell "migration_run" do
        user        app["owner"]
        group       app["group"]
        cwd         app["target_path"]
        environment env_hash
        command     app["migration_command"]
    end
  end


  # executamos script post deploy
  if app["postdeploy_script"]

    perlenv_shell "postdeploy" do    
        user        app["owner"]
        group       app["group"]
        cwd         app["target_path"]
        code        %{bash #{app["target_path"]}/#{app["postdeploy_script"]}}
    end

  end


  # socket que usaremos para comunicar nginx con uwsgi
  mi_socket = "unix:///tmp/#{app["domain"]}.sock"

  # configuramos o backend
  uwsgi_psgi_site app["domain"] do
    app_dir       app["target_path"]
    entry_point   app["entry_point"] 
    socket        mi_socket

    # lanzamos a applicacion con 100 coroutines, 
    coroae        100
  end

  # configuramos o frontend
  nginx_uwsgi_site app["domain"] do
    static_files_path   "#{app["target_path"]}/public"
    uwsgi_socket        mi_socket
    protocol            'perl'
  end

end
