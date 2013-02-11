#require "/home/alambike/proxectos/lxc/shared/cookbooks/rvm/libraries/chef_rvm_string_cache"
require_relative "chef_rvm_string_cache"
require_relative "chef_rvm_shell_helpers"

str = 'ruby-1.9.3'
user = nil

puts Chef::RVM::StringCache::canonical_ruby_string(str,user)
