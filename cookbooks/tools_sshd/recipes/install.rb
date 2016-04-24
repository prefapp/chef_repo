package node['tools']['sshd']['package']

template node['tools']['sshd']['config_file'] do
  source  'sshd_config.erb'
  owner  'root'
  group  'root'
  mode   00755
end

# creamos a carpeta /var/run/sshd
directory "/var/run/sshd" do
  owner "root"
  group "root"
  mode 0755
  action :create
end



# para arrancar o servicio co runit dentro dun container
node.set['container_service']['ssh']['command'] = 
  "/usr/sbin/sshd -D"

service "ssh" do
  action :enable
end 


