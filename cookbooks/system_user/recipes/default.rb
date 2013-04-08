#
# Cookbook Name:: system_user
require 'chef/mixin/shell_out'

include_recipe "shell_lshell"


#creamos un usuario con ese shell
# receta apilable, usaremola asi
node["system"]["users"]["lshell"].each |user| do

	user user["username"] do
		action :create
		comment "lshell user"
		gid user["group"]
		home "/home/#{user["username"]}"
		shell "/bin/lshell"
		password shell_out!("openssl passwd -1 #{user["password"]}")
		supports {:manage_home => true}
		#password "$1$JJsvHslV$szsCjVEroftprNn4JHtDi."
	end

	## para establecer configuracions especificas por usuario
	## usaremos un LWRP
	# lshell_user_conf user["username"] do
	# 	allowed user["allowed"]
	# 	aliases user["aliases"]
	# 	forbidden user["forbidden"]
	# 	intro user["intro"]
	# 	path user["path"]
	# end

end