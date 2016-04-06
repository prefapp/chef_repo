# recipe to install docker-engine

download_url = "https://get.docker.com/builds/#{node['kernel']['name']}"+
  "/#{node['kernel']['machine']}/docker-#{node['tools']['docker']['engine_version']}"

remote_file "/usr/bin/docker" do 
  source download_url
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
