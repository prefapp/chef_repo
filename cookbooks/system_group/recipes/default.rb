#
# Cookbook Name:: system_group
# Recipe:: default
#
node["system"]["groups"]["default"].each do |group|
     
    group group["name"] do
        action :create
        members group["members"] if group.include?("members")
        append group["append_members"]
    end
end