# primeiros pasos
include_recipe "appserver_uwsgi::default"

# librerias de desarrollo de perl (debian, ubuntu)
package "libperl-dev"
package "libpcre3-dev"

target_path = node["appserver"]["uwsgi"]["installation_path"]

if node["lang"]["perl"]["version"] == "system" 
    bash 'compile uWSGI' do
        cwd  target_path
        code <<-EOH
        python uwsgiconfig.py --build psgi
        EOH
    end
else
    #perlbrew
    perlbrew_run "compile uWSGI" do
        cwd target_path
        perlbrew node["lang"]["perl"]["version"]
        command "python uwsgiconfig.py --build psgi"
    end

end

# opcions extra para lanzar unha app perl co uwsgi
node.run_state['uwsgi_run_options'] = {    
    "perl-no-die-catch" =>  ""
}



# configuracion final
include_recipe "appserver_uwsgi::_final_config"