default["lang"]["nodejs"]["version"] = 'latest'

default["lang"]["nodejs"]["packages"] = []

case node['platform_family']
when 'debian'
  default['lang']['nodejs']['repo']         = lazy {

    required_version = node['lang']['nodejs']['version']
    
    debian_repo_string = ''
    
    if required_version == 'latest'
      debian_repo_string = 'node_8.x'
    elsif required_version == 'legacy'
      debian_repo_string = 'node_4.x'
    else 
      debian_repo_string = 'node_6.x'
    end


    "https://deb.nodesource.com/#{debian_repo_string}"
  }
  default['lang']['nodejs']['keyserver']    = 'keyserver.ubuntu.com'
  default['lang']['nodejs']['key']          = '1655a0ab68576280'
when 'rhel', 'amazon'
  release_ver = platform?('amazon') ? 6 : node['platform_version'].to_i
  default['lang']['nodejs']['repo']         = "https://rpm.nodesource.com/pub_6.x/el/#{release_ver}/$basearch"
  default['lang']['nodejs']['key']          = 'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'
end
