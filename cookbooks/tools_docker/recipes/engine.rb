# recipe to install docker-engine

version = node['tools']['docker']['engine_version']

download_url = "https://get.docker.com/builds/#{node['kernel']['name']}"+
  "/#{node['kernel']['machine']}"

if Chef::VersionConstraint.new(">= 1.11.0").include?(version)

  code_repo "/usr/bin/docker_new" do
    target_path "/usr/bin/docker_new"
    provider  Chef::Provider::CodeRepoRemoteArchive
    url download_url
    revision "docker-#{version}.tgz"
    owner  'root'
    group 'root'
    action 'pull'
  end
  
  link "/usr/bin/docker" do
    to "/usr/bin/docker_new/docker"
  end

  link "/usr/bin/docker-containerd" do
    to "/usr/bin/docker_new/docker-containerd"
  end

  link "/usr/bin/docker-containerd-ctr" do
    to "/usr/bin/docker_new/docker-containerd-ctr"
  end

  link "/usr/bin/docker-containerd-shim" do
    to "/usr/bin/docker_new/docker-containerd-shim"
  end

  link "/usr/bin/docker-runc" do
    to "/usr/bin/docker_new/docker-runc"
  end
else

  remote_file "/usr/bin/docker" do 
    source "download_url/docker-#{version}"
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end
