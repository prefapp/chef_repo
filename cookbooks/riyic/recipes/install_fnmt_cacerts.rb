
if node['platform_family'] == 'debian'

  remote_directory '/usr/local/share/ca-certificates/fnmt' do
    source 'certs/fnmt'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
  
  
  execute "update-ca-certificates" do
    command "update-ca-certificates"
    action :run
  end

end
