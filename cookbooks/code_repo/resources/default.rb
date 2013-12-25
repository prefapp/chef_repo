actions :pull, :force_pull
default_action :pull

attribute :target_path,  :kind_of => String, :name_attribute => true
attribute :url,          :kind_of => String
attribute :revision,     :kind_of => String
attribute :owner,        :kind_of => String, :default => "root"
attribute :group,        :kind_of => String, :default => "root"
attribute :ssh_host_key, :kind_of => String
#attribute :remote_user,  :kind_of => String
attribute :credential,   :kind_of => String

# atributos concretos para determinados providers
attribute :unpack_file,  :equal_to => [true,false], :default => true
attribute :files,        :kind_of => Array, :default => []
