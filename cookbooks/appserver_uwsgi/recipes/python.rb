# montamos a base de uwsg
include_recipe "appserver_uwsgi::default"

# librerias de desarrollo de python (debian, ubuntu)
package "python-dev"

target_path = node["appserver"]["uwsgi"]["installation_path"]


['python'].each do |p|
    bash "compile_#{p}" do
        cwd target_path
        code "python uwsgiconfig.py --plugin plugins/#{p} core"
        not_if{File.exists?("#{target_path}/#{p}_plugin.so")}
    end
end

# configuracion final
include_recipe "appserver_uwsgi::_final_config"