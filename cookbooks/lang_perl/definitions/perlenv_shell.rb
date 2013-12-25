define :perlenv_shell, :cwd => '/', :user => 'root', :group => 'root', :environment => {} do

  name = params[:name]
  command = params[:command]
  cwd = params[:cwd] 

  include_recipe "lang_perl::default"

  if node["lang"]["perl"]["version"] == "system" 
      bash name do
        user        params[:user]
        group       params[:group]
        cwd         params[:cwd]
        # flags       '-x'
        environment params[:environment]
        code        command
      end
  else
      #perlbrew
      perlbrew_run name do
        cwd           params[:cwd]
        environment   params[:environment]
        perlbrew      node["lang"]["perl"]["version"]
        command       command
      end

  end

end
