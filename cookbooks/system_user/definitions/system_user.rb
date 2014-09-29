define :system_user, :action=>'create', :shell => '/bin/bash', :group => "users" do  
  username = params[:name]

  if params[:action] == :create
    # nos aseguramos que exista o grupo
    group params[:group]

    user username do
      Chef::Resource::User.send(:include, UserHelper)
      action :create
      comment params[:comment]
      gid params[:group]
      home "/home/#{username}"
      shell params[:shell]
      password generate_password_hash(params[:password])
      supports :manage_home => true
    end

  elsif params[:action] == :remove
    
    user username do
      action :remove
    end
    
  else #manage
    raise "no definida todavia"
    user username do
      action :manage
    end
  end
end