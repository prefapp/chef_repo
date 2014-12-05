# actualizamos primeiro a cache do gestor de paquetes
include_recipe "system_package::update_cache"

if node['platform_family'] == "debian"
  # lanzamos o dist-upgrade tratando de forzar con todas as opcions posibles que non sexa interactivo
	env_hash = {"DEBIAN_FRONTEND" => "noninteractive"}

	execute "dist-upgrade" do
	    environment    env_hash
	    command        "apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade"
	end


end

