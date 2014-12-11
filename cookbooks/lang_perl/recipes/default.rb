#
# instala a version de perl requerida con perlbrew, ou ben a version do sistema
#

unless node["lang"]["perl"]["version"] == "system"  
    include_recipe "lang_perl::perlbrew"

else

    include_recipe "lang_perl::package"
  
end


# instalamos os modulos solicitados

if node["lang"]["perl"]["modules"].length > 0
    
    perlenv_cpanm "#{node["lang"]["perl"]["version"]}-modules" do
        
        modules node["lang"]["perl"]["modules"]

	end 
end
