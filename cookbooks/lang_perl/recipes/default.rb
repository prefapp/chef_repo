#
# instala a version de perl requerida con perlbrew, ou ben a version do sistema
#

if node["lang"]["perl"]["version"] == "system"  

  include_recipe "lang_perl::package"

else

  include_recipe "lang_perl::perlbrew"

end


# instalamos os modulos solicitados

modules = node['lang']['perl']['modules'] + node['lang']['perl']['darkpan_modules']

if modules.length > 0
  # instalar dependencias dende dentro do cpanfile
  perlenv_cpanm "#{node["lang"]["perl"]["version"]}-modules" do
    modules modules
    options '-v --installdeps'
  end

  #instalar modulos
  perlenv_cpanm "#{node["lang"]["perl"]["version"]}-modules" do
    modules modules
    #options '-v'
  end
end
