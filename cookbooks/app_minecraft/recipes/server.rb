app = node["app"]["minecraft"]
service_name = 'minecraftserver'

user "minecraft" do
  comment 'minecraf_user'
  home '/opt/minecraft'
  shell '/bin/bash'
end

directory '/opt/minecraft' do
  owner 'minecraft'
  group 'minecraft'
  mode '0755'
  action :create
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



# si temos seteado o flag e senhal de que estamos dentro dun docker
# seteamos daemon_disable para que arranque en primer plano

if node["riyic"]["inside_container"]
    node.override['minecraftserver']['init_style'] = 'init'
    node.override['minecraftserver']['daemon_disable']  = true
end


node.set['container_service']['minecraftserver']['command'] = 'java -Xmx1024M -Xms1024M -jar /opt/minecraft/minecraft_server.1.8.8.jar nogui'


service "minecraftserver" do
   action [:enable, :start]
end


#runit_service "minecraftserver" do
#  default_logger true
#end

#service 'minecraftserver' do
 #   supports       :status => true, :restart => true, :reload => true
#end


