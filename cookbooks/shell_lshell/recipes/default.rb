#
# Cookbook Name:: shell_lshell
# Recipe:: default
# Installs lshell from repository

# en principio vamos a instalar o python co metodo por defecto da comunidade
# pode que mais adiante necesitemos usar o noso wrapper lang_python
#include_recipe "python::package"

#pasamos de todo, usamos o python da paqueteria
package "python"
package "git-core"

# clonamos o repo de lshell
git "#{Chef::Config[:file_cache_path]}/lshell" do
  repository node["shell"]["lshell"]["repo"]["url"]
  reference node["shell"]["lshell"]["repo"]["reference"]
  action :sync
  notifies :run, "execute[install_lshell]"
end


## instalamos lshell, si nos notifica o recurso git
execute "install_lshell" do
	cwd "#{Chef::Config[:file_cache_path]}/lshell/"
	command "#{Chef::Config[:file_cache_path]}/lshell/setup.py install"
	action :nothing
end

# creamos un enlace en /bin
link "/bin/lshell" do
  to "/usr/local/bin/lshell"
  not_if {File.exists?("/bin/lshell")}
end


directory node["shell"]["lshell"]["config_dir"] do
  mode 00750
  action :create
end

# creamos o ficheiro de conf global
template "#{node["shell"]["lshell"]["config_dir"]}/00global" do
	source "lshell_global_conf.erb"
	mode 00640
	variables(
		:params => node["shell"]["lshell"]["globals"]
	)
end

# creamos o ficheiro de conf defecto e generamos o lconf.conf
lshell_user_conf "01default" do
	user "default"
	options node["shell"]["lshell"]["options"]
end
