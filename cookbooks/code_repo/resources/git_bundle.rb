actions :pull, :force_pull
default_action :pull

# bundle format => target_path|repo_url|revision|list_of_files_comma_separed
attribute :bundle,       :kind_of => Array, :required => true
attribute :owner,        :kind_of => String, :default => "root"
attribute :group,        :kind_of => String, :default => "root"
attribute :ssh_host_key, :kind_of => String
#attribute :remote_user,  :kind_of => String
attribute :credential,   :kind_of => String
attribute :unpack_file,  :equal_to => [true,false], :default => true