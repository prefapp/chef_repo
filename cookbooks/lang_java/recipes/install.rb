
node.set["java"]["jdk_version"] = node['lang']['java']['jdk_version']
node.set["java"]["install_flavor"] = node['lang']['java']['install_flavor']
node.set['java']['oracle']['accept_oracle_download_terms'] = true
#node.set["java"]["java_home"] = '/usr/local/java'

include_recipe "java::default"
