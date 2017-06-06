default["lang"]["nodejs"]["version"] = 'latest'

default["lang"]["nodejs"]["packages"] = []

case node['platform_family']
when 'debian'
  default['lang']['nodejs']['repo']         = 'https://deb.nodesource.com/node_6.x'
  default['lang']['nodejs']['keyserver']    = 'keyserver.ubuntu.com'
  default['lang']['nodejs']['key']          = '1655a0ab68576280'
when 'rhel', 'amazon'
  release_ver = platform?('amazon') ? 6 : node['platform_version'].to_i
  default['lang']['nodejs']['repo']         = "https://rpm.nodesource.com/pub_6.x/el/#{release_ver}/$basearch"
  default['lang']['nodejs']['key']          = 'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'
end
