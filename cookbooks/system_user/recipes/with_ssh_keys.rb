include_recipe "system_user::default"

users = node['system']['users']['zsh'] +
  node['system']['users']['bash'] +
  node['system']['users']['lshell']


users.each do |user|

  content = ''

  keys = user['ssh_keys']

  unless keys.is_a?(Array)

    keys = user['ssh_keys'].split(',')

  end

  keys.each do |key|

    content << key
    
  end

  next if content == ''

  username = user['username']

  directory "#{node['etc']['passwd'][username]['dir']}/.ssh" do
    owner username
    mode 00700
  end

    
  file "#{node['etc']['passwd'][username]['dir']}/.ssh/authorized_keys" do
    content content
    mode 00600
    owner username
  end

end
