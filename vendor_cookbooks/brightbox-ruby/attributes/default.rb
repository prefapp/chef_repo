default['brightbox-ruby']['default_action'] = :upgrade
default['brightbox-ruby']['version'] = '2.1'
default['brightbox-ruby']['install_dev_package'] = true
default['brightbox-ruby']['rubygems_version'] = nil
default['brightbox-ruby']['gems'] = ["bundler", "rake", "rubygems-bundler"]
default['brightbox-ruby']['install_ruby_switch'] = node['platform_version'].to_i < 14
