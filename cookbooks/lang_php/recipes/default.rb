# aseguramos que o metodo de instalacion sexa por paqueteria 
# de momento (ubuntu14 ten no repo php 5.5.9)
node.override["php"]["install_method"] = node['lang_php']['install_method']

include_recipe "php::default"
