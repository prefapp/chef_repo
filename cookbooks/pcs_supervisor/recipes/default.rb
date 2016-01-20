# node.set["supervisor"]["nodaemon"] = true

# arreglo para bug en receta de python con chef-11.6
# node.set['python']['install_method'] = 'package'

include_recipe "supervisor::default"
 
r = resources(template: node['supervisor']['conffile'])
r.cookbook('pcs_supervisor')
r.source('supervisord.conf.erb')
r.variables({
    :inet_port => node['supervisor']['inet_port'],
    :inet_username => node['supervisor']['inet_username'],
    :inet_password => node['supervisor']['inet_password'],
    :supervisord_minfds => node['supervisor']['minfds'],
    :supervisord_minprocs => node['supervisor']['minprocs'],
    :supervisor_version => node['supervisor']['version'],
})

# srv = resources(service: "supervisor")
# # srv.provider Chef::Provider::Service::Upstart
# srv.start_command "/bin/true"
# srv.action "disable"


# para poder setear nodaemon = true, ( como fai dotcloud) non podemos usar supervisor_service
# probablemente necesitaremos crear unha definition
# que sustitua a supervisor_service e solamente genere o archivo de configuracion