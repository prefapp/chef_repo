node["system"]["users"]["zsh"].each do |user|

  next if user['username'] == 'root'

	system_user user["username"] do
		action :create
		group user['group'] if user.include?('group')
		password user["password"]
    shell "/usr/bin/zsh"
	end

end
