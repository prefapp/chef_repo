## para debian/ubuntu que se instale por paqueteria por defecto please!
case node['platform_family']
   when "debian"
       node.set["nodejs"]["install_method"] = 'package'
end


include_recipe "nodejs"
