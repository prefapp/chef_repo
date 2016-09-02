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
# opcions permitidas no configure:
# http://perl5.git.perl.org/perl.git/blob/HEAD:/Configure
# opcions que trae a compilacion de debian: -Dccflags=-DDEBIAN -Dcccdlflags=-fPIC

## todas os simbolos disponhibles que se poden defininir con -D explicadas en
# http://perl5.git.perl.org/perl.git/blob/HEAD:/Porting/Glossary

# TIVEMOS QUE METER -A ccflags=-fPIC para poder compilar os plugins de perl en uwsgi
# ver http://search.cpan.org/dist/mod_perl/docs/user/install/install.pod
options = "-j #{node["cpu"]["total"]} -des -Dusethreads -Duselargefiles -A ccflags=-fPIC"
Chef::Log.info("PERL COMPILATION OPTIONS: #{options}")

# 
# TODO: la compilacion falla desde dentro de un container,
# fallan 2 tests
#
perlbrew_perl node["lang"]["perl"]["version"] do
  action :install
  install_options options
end

# Configure options disponhibles
# http://perl5.git.perl.org/perl.git/blob/HEAD:/Configure
# Usage: $me [-dehrsEKOSV] [-f config.sh] [-D symbol] [-D symbol=value]
#                  [-U symbol] [-U symbol=] [-A command:symbol...]
#   -d : use defaults for all answers.
#   -e : go on without questioning past the production of config.sh.
#   -f : specify an alternate default configuration file.
#   -h : print this help message and exit (with an error status).
#   -r : reuse C symbols value if possible (skips costly nm extraction).
#   -s : silent mode, only echoes questions and essential information.
#   -D : define symbol to have some value:
#          -D symbol         symbol gets the value 'define'
#          -D symbol=value   symbol gets the value 'value'
#        common used examples (see INSTALL for more info):
#          -Duse64bitint            use 64bit integers
#          -Duse64bitall            use 64bit integers and pointers
#          -Dusethreads             use thread support
#          -Dinc_version_list=none  do not include older perl trees in @INC
#          -DEBUGGING=none          DEBUGGING options
#          -Dcc=gcc                 choose your compiler
#          -Dprefix=/opt/perl5      choose your destination
#   -E : stop at the end of questions, after having produced config.sh.
#   -K : do not use unless you know what you are doing.
#   -O : ignored for backward compatibility
#   -S : perform variable substitutions on all .SH files (can mix with -f)
#   -U : undefine symbol:
#          -U symbol    symbol gets the value 'undef'
#          -U symbol=   symbol gets completely empty
#        e.g.:  -Uversiononly
#   -A : manipulate symbol after the platform specific hints have been applied:
#          -A append:symbol=value   append value to symbol
#          -A symbol=value          like append:, but with a separating space
#          -A define:symbol=value   define symbol to have value
#          -A clear:symbol          define symbol to be ''
#          -A define:symbol         define symbol to be 'define'
#          -A eval:symbol=value     define symbol to be eval of value
#          -A prepend:symbol=value  prepend value to symbol
#          -A undef:symbol          define symbol to be 'undef'
#          -A undef:symbol=         define symbol to be ''
#        e.g.:  -A prepend:libswanted='cl pthread '
#               -A ccflags=-DSOME_MACRO
#   -V : print version number and exit (with a zero status).
