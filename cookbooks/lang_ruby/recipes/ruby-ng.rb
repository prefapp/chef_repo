#recalculamos o gemdir segun a version de ruby
gems_dir = {
    'ruby-2.2' => '2.2.0',
    'ruby-2.1' => '2.1.0',
    'ruby-2.0.0' => '2.0.0',
    'ruby-1.9.3' => '1.9.1'
}

# atributos necesarios para passenger
node.set["lang"]["ruby"]["version_long"] = node['lang']['ruby']['version']
node.set['lang']['ruby']['gemdir'] = "/var/lib/gems/#{gems_dir[node['lang']['ruby']['version']]}"
node.set["lang"]["ruby"]["binary_path"] = "/usr/bin/ruby"
node.set["lang"]["ruby"]["wrapper"] = ''
 
# version de ruby a instalar
node.set["brightbox-ruby"]["version"] = node["lang"]["ruby"]["version"].gsub(/^ruby\-/,'')

node.set["brightbox-ruby"]["gems"] = 
    node["brightbox-ruby"]["gems"] | node["lang"]["ruby"]["gems"]


# ruby 1.9.3 hasn't dev packages nowadays in ubuntu 14
if node["brightbox-ruby"]["version"] == '1.9.3'
    node.set['brightbox-ruby']['install_dev_package'] = false
end

include_recipe "brightbox-ruby::default"
