define :lshell_user_conf, :enable=>true, :template=>"lshell_user_conf.erb", :options => {} do
  include_recipe "shell_lshell"
  
  file = params[:name]
  user = params[:user] || params[:name]
  cb = params[:cookbook] || 'shell_lshell'

  if params[:enable]
    
    next if !params[:options] || params[:options].empty?

    template "#{node["shell"]["lshell"]["config_dir"]}/#{file}" do
      source params[:template]
      mode 00640
      cookbook cb
      variables(
        :user => user,
        :params => params[:options]
      )
      notifies :create, "ruby_block[generate_lshell.conf]"
    end

  else
    file "#{node["shell"]["lshell"]["config_dir"]}/#{file}" do
      action :delete
      notifies :create, "ruby_block[generate_lshell.conf]"
    end
  end


  ## regeneramos lshell.conf
  ## xuntando todos os archivos de configuracion de lshell.d
  #contenido = join_files(node["shell"]["lshell"]["config_dir"])

  ruby_block "generate_lshell.conf" do
    block do
      Chef::Resource::RubyBlock.send(:include, LshellHelper)
      contenido = join_files(node["shell"]["lshell"]["config_dir"])
      f = ::File.open(node["shell"]["lshell"]["config_file"],"w")
      f.write(contenido)
    end
    action :nothing
  end

  # usamos o ruby_block porque
  # non se permiten lambdas, para calcular os params en tempo de execucion
  # en vez de en tempo de compilacion
  # http://tickets.opscode.com/browse/CHEF-1814

  # file "#{node["shell"]["lshell"]["config_file"]}" do
  #   Chef::Resource::File.send(:include, LshellHelper)
  #   owner "root"
  #   group "root"
  #   content lambda{join_files(node["shell"]["lshell"]["config_dir"])}
  #   mode 00644
  #   action :create
  # end
end
