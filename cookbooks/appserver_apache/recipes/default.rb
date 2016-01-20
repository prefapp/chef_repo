#server = node["appserver"]["apache"]
#
###seteamos os atributos da receta de apache2, a partir dos nosos
#node.set["apache"]["listen_ports"] = server["listen_ports"]
#node.set["apache"]["timeout"] = server["timeout"]
#node.set["apache"]["default_modules"] = server["default_modules"]
#node.set["apache"]["mpm"] = server["appserver"]["mpm"]


# seteamos os atributos para o cookbook de apache, a partir dos nosos atributos

node.set["apache"] = node["appserver"]["apache"]
include_recipe "apache2"
