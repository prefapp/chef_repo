## PARA RECARGARGA DE ATRIBUTOS EN TEMPO DE EXECUCION !!!!
# xa non o utilizamos porque non basta con esto para recargar as opcions
# de compilacion do nginx, xa que estan dentro de node.run_state e non se da
# recargado en tempo de execuccion
#::Chef::Node.send(:include, RVMHelpers)
#
#node.set["lang"]["ruby"]["gemdir"] = gem_dir
#node.set["lang"]["ruby"]["binary_path"] = ruby_path
#node.set["lang"]["ruby"]["wrapper"] = ruby_wrapper
#
## usamos gem_dir e ruby_path, 2 helpers definidos no cookbook lang_ruby
#node.set["nginx"]["passenger"]["root"] = "#{gem_dir}/gems/passenger-#{node['appserver']['version']}"
#node.set["nginx"]["passenger"]["ruby"] = ruby_wrapper
#Chef::Log.error("PASSENGER_ROOT: #{node['nginx']['passenger']['root']} ")
#Chef::Log.error("PASSENGER_RUBY: #{ruby_wrapper}")

node.default["lang"]["ruby"]["version"] = "ruby-1.9.3"

ruby_versions = { 'ruby-1.9.3' => 'ruby-1.9.3-p374', #'ruby-1.9.3-p385',
                  'ruby-1.9.2' => 'ruby-1.9.2-p320',
                  'ruby-1.8.7' => 'ruby-1.8.7-p371',
                }

version = ruby_versions[node["lang"]["ruby"]["version"]]


## establecemos as rutas estaticamente
node.set["lang"]["ruby"]["version_long"] = version
node.set["lang"]["ruby"]["gemdir"] = "/usr/local/rvm/gems/#{version}"
node.set["lang"]["ruby"]["binary_path"] = "/usr/local/rvm/rubies/#{version}/bin/ruby"
node.set["lang"]["ruby"]["wrapper"] = "/usr/local/rvm/wrappers/#{version}/ruby"


# version de rails, por defecto vacio para que colla a ultima
node.default["lang"]["ruby"]["rails"]["version"] = nil
