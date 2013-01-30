
ruby = node["lang"]["ruby"]

##seteamos chef-rvm params
#node.set['rvm']['default_ruby'] = ruby["version"]
#node.set['rvm']['user_default_ruby'] = ruby["version"]
#
#node.set['rvm']['global_gems'] = ruby["gems"]
#
#str = ruby["version"]

str << "@#{ruby["gemset"]}" unless ruby["gemset"].empty?

rvm_default_ruby str do
    action :create
    user ruby["user"] unless ruby["user"].empty?
end

## instatalamos as gemas solicitadas no gemset establecido
ruby.gems.each do |gem|
    (gem_name, gem_version) = gem.split('#')

    rvm_gem gem_name do
        ruby_string = str
        action :install
        version = gem_version unless gem_version.empty?
    end
end
