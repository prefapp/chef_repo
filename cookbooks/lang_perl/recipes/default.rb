#
# instala a version de perl requerida con perlbrew, ou ben a version do sistema
#

unless node["lang"]["perl"]["version"] == "system"  

  include_recipe "lang_perl::perlbrew"

else

  package "perl"

end

