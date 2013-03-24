ruby = node["lang"]["ruby"]

str = ruby["version_long"]
str << "@#{ruby["gemset"]}" unless ruby["gemset"].empty?

###seteamos chef-rvm params
node.set['rvm']['default_ruby'] = str
node.set['rvm']['user_default_ruby'] = str

# construimos o atributo que instale as gemas no sistema
gems = []
ruby["gems"].each do |gem|
    g = {}
    (gem_name, gem_version) = gem.split('#')
    g["name"] = gem_name
    g["version"] = gem_version unless gem_version.nil?

    gems.push(g)
end

node.set['rvm']['global_gems'] = (gems.empty?)? nil: gems 
node.set["rvm"]["user_global_gems"] = node.set['rvm']['global_gems'] 

#instalamos ruby 
include_recipe "rvm::system"


# RECARGA DE ATRIBUTOS EN TEMPO DE EXECUCION!! ####################
# xa non a usamos pero queda para referencia
# e node.load_attribute_by_short_filename non chuta en chef 11
#execute 'foo' do
#  command 'which ruby'
#  notifies :create, 'ruby_block[reload_attributes]', :immediately
#end
#
#ruby_block 'reload_attributes' do
#	block do 
#        node.load_attribute_by_short_filename('default', 'lang_ruby')
#        Chef::Log.info("RUTA RUBY: #{node["lang"]["ruby"]["binary_path"]}")
#    end
#    action :nothing
#end
####################################################################

## seteamos o provider de rvm
# como default provider para o recurso gem_package
node.set['rvm']['gem_package']['rvm_string'] = str
include_recipe "rvm::gem_package"


## seteamos as rutas de ruby
# para q as poidan usar outras recetas

#node.override['lang']['ruby']['gemdir'] = gem_dir
#node.override['lang']['ruby']['binary_path'] = ruby_path
#node.override['lang']['ruby']['wrapper'] = ruby_wrapper
#Chef::Log.info("RUTA RUBY: #{node["lang"]["ruby"]["binary_path"]}, RUTA GEMAS: #{gem_dir}, WRAPPER #{ruby_wrapper}")


#include_recipe "rvm::system"


## instalamos rvm e cargamos os lwrps
#include_recipe "rvm::system_install"
#
#rvm_default_ruby str do
#    action :create
#    user ruby["user"] unless ruby["user"].empty?
#end
#
### instatalamos as gemas solicitadas no gemset establecido
#ruby["gems"].each do |gem|
#    (gem_name, gem_version) = gem.split('#')
#
#    rvm_gem gem_name do
#        ruby_string = str
#        action :install
#        version = gem_version unless gem_version.nil?
#    end
#end
