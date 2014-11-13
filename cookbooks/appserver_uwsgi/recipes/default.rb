# requisitos para todas as recetas (psgi, python...)
# e para os providers
include_recipe "lang_python::default"

include_recipe "pcs_supervisor::default"

include_recipe "code_repo::default"

include_recipe "build-essential::default"

# download code
code_repo node["appserver"]["uwsgi"]["installation_path"] do

  provider    Chef::Provider::CodeRepoRemoteArchive
  url         node["appserver"]["uwsgi"]["url"]
  revision    "uwsgi-#{node["appserver"]["uwsgi"]["version"]}.tar.gz"
  owner       "root"
  group       "root" 
  action      "pull"

end

# compilamos o core, o resto vai como plugin
bash 'compile uWSGI' do
    cwd  node["appserver"]["uwsgi"]["installation_path"]
    code <<-EOH
    python uwsgiconfig.py --build core
    EOH
    not_if do
        File.exists?("#{node["appserver"]["uwsgi"]["installation_path"]}/uwsgi") &&
        Mixlib::ShellOut.new("uwsgi --version").run_command.stdout.split("\n").include?(node["appserver"]["uwsgi"]["version"])
    end
end

# compile
# incluimos as recetas concretas de cada lenguaje, porque hai que instalar librerias e demais
# node.run_state['uwsgi_plugins'] = []
# node.run_state['uwsgi_builds'] = []
# node['appserver']['uwsgi']['modules'].each do |mod|
#   include_recipe "appserver_uwsgi::#{mod}"
# end

# # si queremos compilar cada lenguaje como un plugin
# if node["appserver"]["uwsgi"]["standalone"] == "no"

#   plugins = node.run_state['uwsgi_plugins'].map{|p| "--plugin plugins/#{p}"}

#   # crear un provider (compile_with_env)
#   # que lle poidas pasar variables de entorno
#   # que lle poidas pasar source scripts
#   # que lle poidas meter pre e post comandos antes do commando que vai a executar

#   bash 'compile uWSGI' do
#     cwd  target_path
#     code <<-EOH
#       python uwsgiconfig.py --build core &&
#       python uwsgiconfig.py #{plugins.join(" ")} core
#     EOH
#   end

# else
# # si o que queremos e construir un unico binario con soporte para os diferentes lenguajes escollidos

#   builds = node.run_state['uwsgi_builds'].map{|p| "--build #{p}"}

#   bash 'compile uWSGI' do
#     cwd  target_path
#     command <<-EOH
#       python uwsgiconfig.py #{builds.join(" ")}
#     EOH
#   end

# end

