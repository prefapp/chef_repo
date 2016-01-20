# default recipe
# create system users with no shell

node["system"]["users"]["default"].each do |user|

    user user["username"] do
        action :create
        system true
        shell "/bin/false"
    end
end
