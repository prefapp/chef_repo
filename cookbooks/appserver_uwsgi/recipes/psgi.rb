# montamos a base de uwsg
include_recipe "appserver_uwsgi::default"

# librerias de desarrollo de perl (debian, ubuntu)
package "libperl-dev"
package "libpcre3-dev"

target_path = node["appserver"]["uwsgi"]["installation_path"]

# para instalar os modulos de cpan usamos o provider de lang_perl->perlenv_cpanm
# que distingue si temos instalado perl dende os paquetes do sistema ou con perlbrew
perlenv_cpanm 'Install Coro::AnyEvent module' do
    modules ['Coro::AnyEvent']
end

build_plugins = %w[psgi coroae]

# if node["appserver"]["uwsgi"]["psgi"]["coroae"] == "yes"
#     perlenv_cpanm 'Install Coro::AnyEvent module' do
#         modules ['Coro::AnyEvent']
#     end

#     build_plugins.push("coroae")

# end

# compilamos os plugins solicitados, 
# dentro do entorno que temos seleccionado en lang_perl (system, perlbrew ...)
build_plugins.each do |p|
    perlenv_shell "compile_#{p}" do
        cwd target_path
        command "python uwsgiconfig.py --plugin plugins/#{p} core"
        not_if{File.exists?("#{target_path}/#{p}_plugin.so")}
    end
end


# opcions extra para lanzar unha app perl co uwsgi
# node.run_state['uwsgi_run_options'] = {    
#     "perl-no-die-catch" =>  ""
# }


# configuracion final
include_recipe "appserver_uwsgi::_final_config"