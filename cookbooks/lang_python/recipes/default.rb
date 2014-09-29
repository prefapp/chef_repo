include_recipe "python::default"

Array(node["lang"]["python"]["packages"]).each do |p|
    (name,version) = p.split('#')

    python_pip name do
        version version if(version)
    end
end

