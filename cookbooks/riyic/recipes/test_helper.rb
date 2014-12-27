require 'chef/mixin/deep_merge'

directory '/tmp/serverspec' do
    recursive true
end

node_json_file = '/tmp/serverspec/node.json'

file node_json_file do
    owner 'root'
    mode '0400'
end

Chef::Log.info("Dumping node attributes to #{node_json_file}")


ruby_block "dump_node_attributes" do

    block do

        attrs = {}
    
        attrs = Chef::Mixin::DeepMerge.merge(attrs,node.default_attrs) unless node.default_attrs.empty?
        attrs = Chef::Mixin::DeepMerge.merge(attrs,node.normal_attrs) unless node.normal_attrs.empty?
        attrs = Chef::Mixin::DeepMerge.merge(attrs,node.override_attrs) unless node.override_attrs.empty?
        attrs = Chef::Mixin::DeepMerge.merge(attrs,node.automatic_attrs) unless node.automatic_attrs.empty?

        #recipe_json = "{ \"run_list\": \[ "
        #    recipe_json << node.run_list.expand(node.chef_environment).recipes.map! { |k| "\"#{k}\"" }.join(",")
        #    recipe_json << " \] }"
        #attrs = attrs.deep_merge(JSON.parse(recipe_json))

        attrs = Chef::Mixin::DeepMerge.merge(attrs,{"run_list" => node.run_list})

        File.open(node_json_file, 'w') do |f|
            f.write(JSON.pretty_generate(attrs))
            #f.write(Chef::JSONCompat.to_json_pretty(attrs))
        end
    end

end
