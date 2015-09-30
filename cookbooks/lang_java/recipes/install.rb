
node.set['java']['jdk_version'] = node['lang']['java']['jdk_version']
node.set['java']['install_flavor'] = node['lang']['java']['install_flavor']

include_recipe "java::default"
