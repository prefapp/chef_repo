# recipe to install docker-engine

version = node['tools']['docker']['engine_version']

download_url = "https://get.docker.com/builds/#{node['kernel']['name']}"+
  "/#{node['kernel']['machine']}"

if Chef::VersionConstraint.new(">= 1.11.0").include?(version)

  code_repo "/usr/bin/" do
    provider  Chef::Provider::CodeRepoRemoteArchive
    url       download_url
    revision  "docker-#{version}.tgz"
    owner     'root'
    group     'root'
    action    'pull'
  end
  
else

  remote_file "/usr/bin/docker" do 
    source    "#{download_url}/docker-#{version}"
    owner     'root'
    group     'root'
    mode      '0755'
    action    :create
  end
end
