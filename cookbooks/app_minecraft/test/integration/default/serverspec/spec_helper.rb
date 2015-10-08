require 'serverspec'

require 'json'

Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

set :backend, :exec

node_attributes_file = '/tmp/serverspec/node.json'


$node = (File.readable?(node_attributes_file))? ::JSON.parse(File.read(node_attributes_file) || '{}') : nil
