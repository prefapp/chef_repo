#
# recipe to download docker-machine
#

download_url = "https://github.com/docker/machine/releases/download/#{node['tools']['docker']['machine_version']}/"+
  "/docker-machine-#{node['kernel']['name']}-#{node['kernel']['machine']}"

remote_file "/usr/local/bin/docker-machine" do 
  source download_url
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
