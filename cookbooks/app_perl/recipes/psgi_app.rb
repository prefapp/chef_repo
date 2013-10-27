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
  # rvm_shell "bundle install" do    
  #     user        app["owner"]
  #     group       app["group"]
  #     cwd         app["target_path"]
  #     environment env_hash
  #     ## fundamental meter o --path dentro do propio deploy, senon trata de instalar no home do usuario que lance o sudo
  #     code        %{bundle install --path=vendor/bundle --binstubs --without #{app["exclude_bundler_groups"].join(' ')}}
  # end


  # aplicamos a migracion
  # if app["migrate"] == "yes"

  #   rvm_shell "rake db:migrate" do    
  #           user        app["owner"]
  #           group       app["group"]
  #           cwd         "#{app["target_path"]}"
  #           environment env_hash
  #           code        "bundle exec rake db:migrate"
  #   end

  # end


  # executamos script post deploy
  if app["postdeploy_script"]
    # rvm_shell "postdeploy" do    
    #     user        app["owner"]
    #     group       app["group"]
    #     cwd         app["target_path"]
    #     environment env_hash
    #     code        %{bash #{app["target_path"]}/#{app["postdeploy_script"]}}
    # end
    
    # co -l -c NON FAI FALTA meter o bash nun rvm_shell, pero ambos funcionan perfectamente
    bash "postdeploy" do    
        user        app["owner"]
        group       app["group"]
        cwd         app["target_path"]
        code        %{bash -l -c #{app["target_path"]}/#{app["postdeploy_script"]}}
    end

  end


  # configuramos o frontend + backend
  nginx_psgi_site app["domain"] do
    static_files_path "#{app["target_path"]}/public"
    # service_location "apatrullando"
  end

end
