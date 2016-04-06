#
# recipe to install docker compose
#
download_url = "https://github.com/docker/compose/releases/download/#{node['tools']['docker']['compose_version']}"+
  "/docker-compose-#{node['kernel']['name']}-#{node['kernel']['machine']}"

remote_file "/usr/local/bin/docker-compose" do 
  source download_url
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
