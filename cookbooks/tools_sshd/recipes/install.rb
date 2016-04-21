package node['tools']['sshd']['package']

template node['tools']['sshd']['config_file'] do
  source  'sshd_config.erb'
  owner  'root'
  group  'root'
  mode   00755
end




