ruby = node["lang"]["ruby"]

###seteamos chef-rvm params
#node.set['rvm']['default_ruby'] = ruby["version"]
#node.set['rvm']['user_default_ruby'] = ruby["version"]
#
#
#gems = []
#ruby["gems"].each do |gem|
#    g = {}
#    (gem_name, gem_version) = gem.split('#')
#    g["name"] = gem_name
#    g["version"] = gem_version unless gem_version.empty?
#
#    gems.push(g)
#end
#
#node.set['rvm']['global_gems'] = gems
#node.set["rvm"]["user_global_gems"] = gems
#include_recipe "rvm::system"

include_recipe "rvm"
str = ruby["version"]
str << "@#{ruby["gemset"]}" unless ruby["gemset"].empty?

rvm_default_ruby str do
    action :create
    user ruby["user"] unless ruby["user"].empty?
end

## instatalamos as gemas solicitadas no gemset establecido
ruby["gems"].each do |gem|
    (gem_name, gem_version) = gem.split('#')

    rvm_gem gem_name do
        ruby_string = str
        action :install
        version = gem_version unless gem_version.nil?
    end
end
