## para debian/ubuntu que se instale por paqueteria por defecto please!
case node['platform_family']
   when "debian"
       if node["lang"]["nodejs"]["version"] == 'latest'
           node.set["nodejs"]["install_method"] = 'package'

       elsif node["lang"]["nodejs"]["version"] == 'legacy'
           node.set["nodejs"]["install_method"] = 'package'
           node.set['nodejs']['legacy_packages'] = true
       else
           node.set["nodejs"]["install_method"] = "binary"
           node.set["nodejs"]["check_sha"] = false
       end
end


include_recipe "nodejs::default"

# instalamos a lista de modulos solicitados
# de forma global

node["lang"]["nodejs"]["packages"].each do |p|

    bash "install_#{p}" do
        code "npm install #{p} --global"
    end
end
