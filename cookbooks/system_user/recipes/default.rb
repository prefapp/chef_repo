#
# Cookbook Default recipe:: system_user

#creamos un usuario coa shell por defecto (bash)
# receta apilable, usaremola asi
node["system"]["users"]["default"].each do |user|

	system_user user["username"] do
		action :create
		group user['group'] if user.include?('group')
		password user["password"]
	end
end
