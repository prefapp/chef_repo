
execute "update-tzdata" do
  command "dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

package "tzdata"

file "/etc/timezone" do
  owner "root"
  group "root"
  mode "00644"
  content node['riyic']['system_timezone']
  notifies :run, "execute[update-tzdata]", :immediately
end
