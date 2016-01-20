#
# Cookbook Name:: rvm
# Recipe:: system_install
#
# Copyright 2010, 2011 Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'rvm'

# Build the rvm group ahead of time, if it is set. This allows avoiding
# collision with later processes which may set a guid explicitly
if node['rvm']['group_id'] != 'default'
  g = group 'rvm' do
    group_name 'rvm'
    gid        node['rvm']['group_id']
    action     :nothing
  end
  g.run_action(:create)
end


execute 'Adding gpg key' do
  environment ({"HOME" => "/root", "USER" => "root"})
  command "`which gpg2 || which gpg` --keyserver #{node['rvm']['gpg_keyserver']} --recv-keys #{node['rvm']['gpg_key']}"
  only_if 'which gpg2 || which gpg'
  not_if { node['rvm']['gpg_key'].empty? }
  not_if "`which gpg2 || which gpg` --list-keys | fgrep #{node['rvm']['gpg_key']}"
end

rvm_installation("root")
