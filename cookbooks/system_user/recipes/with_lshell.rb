#
# Cookbook Name:: system_user

if node['system']['users']['lshell'].size == 0
  return
end


include_recipe "shell_lshell"

#creamos un usuario con ese shell
# receta apilable, usaremola asi
node["system"]["users"]["lshell"].each do |user|
  next if user['username'] == 'root'

	system_user user["username"] do
		action :create
		shell '/bin/lshell'
		group user['group']
		password user["password"]
	end

	## para establecer configuracions especificas por usuario
	## usamos unha definition do cookbook shell_lshell
	lshell_user_conf user["username"] do 
		options user["shell_options"]
	end

end
