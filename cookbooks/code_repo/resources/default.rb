actions :pull, :force_pull
default_action :pull

attribute :target_path,  :kind_of => String, :name_attribute => true
attribute :url,          :kind_of => String
attribute :revision,     :kind_of => String
attribute :owner,        :kind_of => String
attribute :group,        :kind_of => String
attribute :ssh_host_key, :kind_of => String
#attribute :remote_user,  :kind_of => String
attribute :credential,   :kind_of => String
attribute :unpack_file,  :equal_to => [true,false], :default => true
