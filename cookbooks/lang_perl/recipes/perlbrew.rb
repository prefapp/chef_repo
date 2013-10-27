# install perl version with perlbrew

node.set["perlbrew"]["perlbrew_root"] = node["lang"]["perl"]["perlbrew"]["perlbrew_root"]

node.set["perlbrew"]["self_upgrade"] = (node["lang"]["perl"]["perlbrew"]["self_upgrade"] == "yes") 

# evitamos que a default recipe instale ningun perl
node.set["perlbrew"]["perls"] = []

# options = ""
# node["lang"]["perl"]["perlbrew"]["install_options"].each do |k,v|
#   options << " -#{k}"
#   options << " #{v}" unless v==""
# end
include_recipe "perlbrew::default"

# instalamos a version de perlbrew requerida
options = "-j #{node["cpu"]["total"]} -Dusethreads}"
Chef::Log.info("Opcions de compilacion #{options}")

perlbrew_perl node["lang"]["perl"]["version"] do
  action :install
  #version  "mi_version_perl"
  install_options options
end

# instalamos os modulos solicitados

if node["lang"]["perl"]["modules"].length > 0
  perlbrew_cpanm "#{node["lang"]["perl"]["version"]}-modules" do
    perlbrew node["lang"]["perl"]["version"]
    modules node["lang"]["perl"]["modules"]
  end 
end
