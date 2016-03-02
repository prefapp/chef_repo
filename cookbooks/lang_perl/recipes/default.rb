#
# instala a version de perl requerida con perlbrew, ou ben a version do sistema
#

if node["lang"]["perl"]["version"] == "system"  

  include_recipe "lang_perl::package"

else

  include_recipe "lang_perl::perlbrew"

end


# instalamos os modulos solicitados

if node["lang"]["perl"]["modules"].length > 0
  
  perlenv_cpanm "#{node["lang"]["perl"]["version"]}-modules" do
    modules node["lang"]["perl"]["modules"]
    options '-v --installdeps'
  end 

end

#
# instalamos modulos privados (darkpan)
#
if node['lang']['perl']['darkpan_modules'].length > 0

  perlenv_cpanm "darkpan-modules" do
    modules node['lang']['perl']['darkpan_modules']
    options '-v --installdeps'
  end

end
