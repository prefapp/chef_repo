app = node["app"]["minecraft"]

user minecraft do
  comment 'minecraf_user'
  home '/opt/minecraft'
  shell '/bin/bash'
end

remote_file '/opt/minecraft/minecraft_server.1.8.8.jar' do
  source 'https://s3.amazonaws.com/Minecraft.Download/versions/1.8.8/minecraft_server.1.8.8.jar'
  owner 'minecraft'
  group 'minecraft'
  mode '0755'
  action :create
end

template "/opt/minecraft/server.properties" do
  source      'server.properties.erb'
  cookbook    'app_minecraft'
  user        'minecraft'
  group       'minecraft'
  variables   ({
     :app => app,
  })
end

file '/opt/minecraft/ops.txt' do
  content node["app"]["minecraft"]["opname"] 
  mode '0755'
  owner 'minecraft'
  group 'minecraft'
end

file '/opt/minecraft/banned-players.txt' do
  content ''
  mode '0755'
  owner 'minecraft'
  group 'minecraft'
end

file '/opt/minecraft/banned-ips.txt' do
  content ''
  mode '0755'
  owner 'minecraft'
  group 'minecraft'
end

