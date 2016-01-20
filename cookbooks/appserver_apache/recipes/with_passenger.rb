#
# Cookbook Name:: passenger_apache2
# Recipe:: source
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

include_recipe "build-essential"
include_recipe 'appserver_apache'

## seteamos atributos para o cookbook base (appserver)
node.set["appserver"]["id"] = "apache_with_passenger"
node.set["appserver"]["version"] = node["appserver"]["apache"]["passenger"]["version"]

# como vamos a usar rvm, temos que setear manualmente o path da instalacion de ruby
node.set["appserver"]["apache"]["passenger"]["root"] = 
    "#{node['lang']['ruby']['gemdir']}/gems/passenger-#{node['appserver']["apache"]["passenger"]['version']}"
node.set["appserver"]["apache"]["passenger"]["module"] = 
    "#{node["appserver"]["apache"]["passenger"]["root"]}/ext/apache2/mod_passenger.so"

server = node['appserver']['apache']

case node['platform_family']
when "arch"
  package "apache"
when "rhel"
  package "httpd-devel"
  if node['platform_version'].to_f < 6.0
    package 'curl-devel'
  else
    package 'libcurl-devel'
    package 'openssl-devel'
    package 'zlib-devel'
  end
else
  apache_development_package =  if %w( worker threaded ).include? server['mpm']
                                  'apache2-threaded-dev'
                                else
                                  'apache2-prefork-dev'
                                end
  %W( #{apache_development_package} libapr1-dev libcurl4-gnutls-dev ).each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end

gem_package "passenger" do
    version server['passenger']['version']
end

## como usamos rvm, necesitamos usar o rvm_shell para ter acceso a version adecuada de ruby
rvm_shell "install passenger" do
    code 'passenger-install-apache2-module --auto'
    creates server["passenger"]["module"]
    not_if { ::File.exists?(server["passenger"]["module"]) }
end

if platform_family?('debian')
    template "#{node['apache']['dir']}/mods-available/passenger.load" do
        source 'passenger.load.erb'
        owner 'root'
        group 'root'
        mode 0755

        variables(
            :passenger_module => server["passenger"]["module"]

        )
    end
end

template "#{node['apache']['dir']}/mods-available/passenger.conf" do
  source 'passenger.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
            :passenger_pool_size => server["passenger"]["max_pool_size"],
            :passenger_root => server["passenger"]["root"],
            :passenger_ruby => node["lang"]["ruby"]["wrapper"]
  )
end


## habilitamos o modulo compilado
apache_module 'passenger' do
  module_path server["passenger"]["module"]
end
