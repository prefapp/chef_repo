#
# Cookbook Name:: system_user
#require 'chef/mixin/shell_out'

include_recipe "shell_lshell"


#creamos un usuario con ese shell
# receta apilable, usaremola asi
node["system"]["users"]["lshell"].each do |user|
	
	cmd = Mixlib::ShellOut.new("openssl passwd -1 #{user["password"]}")
	pass_hash = cmd.run_command.stdout.chomp
	
	user user["username"] do
		action :create
		comment "lshell user"
		gid user["group"]
		home "/home/#{user["username"]}"
		shell "/bin/lshell"
		password pass_hash
		supports :manage_home => true
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