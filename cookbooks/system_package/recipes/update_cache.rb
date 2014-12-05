ultima_actualizacion = Time.new(2000)

if node['platform_family'] == "debian"
    if File.exists?('/var/lib/apt/periodic/update-success-stamp')
        ultima_actualizacion = File.mtime('/var/lib/apt/periodic/update-success-stamp')
    end
    
    if  ultima_actualizacion < Time.now - 86400
      execute "apt-get update" do
          ignore_failure true
          action :nothing
      end.run_action(:run) 
    end

    # instalamos o paquete update-notifier-common (EN EXECUCION)
    # o cal provee varias configuracions para apt, unha delas se encarga de actualizar
    # /var/lib/apt/periodic/update-success-stamp cada vez que corre apt

    p = package "update-notifier-common"
    p.run_action(:install)
end