if node['platform_family'] == "debian"
  # lanzamos o dist-upgrade tratando de forzar con todas as opcions posibles que non sexa interactivo
  env_hash = {"DEBIAN_FRONTEND" => "noninteractive"}

  bash "clean" do
    environment    env_hash
    code           "apt-get -y clean autoclean && apt-get -y autoremove && rm -rf /var/lib/{apt,log,cache}"
  end

end
