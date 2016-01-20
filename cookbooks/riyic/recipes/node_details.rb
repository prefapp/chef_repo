## incluimos a receta por defecto do chef-handler para que faga o deploy dos handlers
include_recipe "chef_handler"

## creando unha receta nodeinform que envie toda a info do nodo
chef_handler "Riyic::Report" do
  source "/var/chef/handlers/riyic_report.rb"

  arguments :auth_token => node['riyic']['key'], 
            :server_id => node['riyic']['server_id'],
            :env => node['riyic']['env'],
            :node_details => true

  action :nothing
end.run_action(:enable)

