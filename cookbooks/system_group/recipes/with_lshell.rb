#
# Cookbook Name:: system_user

include_recipe "shell_lshell"


# receta apilable
node["system"]["groups"]["lshell"].each do |group|
	
	
	group group["name"] do
		action :create
		members group["members"] if group.include?("members")
		append group["append_members"]
	end

	## para establecer configuracions especificas por grupo
	## usamos unha definition do cookbook shell_lshell
	lshell_user_conf "grp:#{group["name"]}" do 
		options group["shell_options"]
	end

end
