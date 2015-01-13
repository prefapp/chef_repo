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

# instalamos a version de perl solicitada
# opcions que trae a compilacion de debian: -Dccflags=-DDEBIAN -Dcccdlflags=-fPIC

# TIVEMOS QUE METER -A ccflags=-fPIC para poder compilar os plugins de perl en uwsgi
# ver http://search.cpan.org/dist/mod_perl/docs/user/install/install.pod
options = "-j #{node["cpu"]["total"]} -Dusethreads -Duselargefiles -A ccflags=-fPIC"
Chef::Log.info("PERL COMPILATION OPTIONS: #{options}")

perlbrew_perl node["lang"]["perl"]["version"] do
  action :install
  install_options options
end


