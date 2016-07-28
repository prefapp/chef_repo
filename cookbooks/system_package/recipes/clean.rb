if node['platform_family'] == "debian"
  # lanzamos o dist-upgrade tratando de forzar con todas as opcions posibles que non sexa interactivo
  env_hash = {"DEBIAN_FRONTEND" => "noninteractive"}

  execute "clean" do
	  environment    env_hash
	  command        "apt-get -y clean && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*"
	end

end
