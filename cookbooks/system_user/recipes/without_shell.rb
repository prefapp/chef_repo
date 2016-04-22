node["system"]["users"]["without_shell"].each do |user|

  next if user['username'] == 'root'

    user user["username"] do
        action :create
        system true
        shell "/bin/false"
    end
end
