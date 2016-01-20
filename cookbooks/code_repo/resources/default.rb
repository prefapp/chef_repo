actions :pull, :force_pull
default_action :pull

attribute :target_path,  :kind_of => String, :name_attribute => true
attribute :url,          :kind_of => String, :required => true
attribute :revision,     :kind_of => String
attribute :owner,        :kind_of => String, :default => "root"
attribute :group,        :kind_of => String, :default => "root"
attribute :ssh_host_key, :kind_of => String
attribute :depth,        :kind_of => Integer
attribute :credential,   :kind_of => String
# si purge_target_path = true se borra o target_path antes de facer o pull
attribute :purge_target_path,   :kind_of => [String,NilClass], :default => nil

# atributos concretos para determinados providers
attribute :unpack_file,  :equal_to => [true,false], :default => true
attribute :files,        :kind_of => Array, :default => []
