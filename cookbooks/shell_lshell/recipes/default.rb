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
  repository node["util"]["lshell"]["repo"]["url"]
  reference node["util"]["lshell"]["repo"]["reference"]
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


# template "lshell.conf"
# 	commands 
# 	alias

# end