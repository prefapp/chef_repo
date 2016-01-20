# instalamos os paquetes de sistema que nos indican
# usando o recurso "package" que nos proporciona chef
node["system"]["packages"]["list"].each do |p|
    # se ve no formato de debian "package=version"
    # extraemos as partes
    p,v = p.split("=")
    package p do
        version v if v
        action :install
    end
end
