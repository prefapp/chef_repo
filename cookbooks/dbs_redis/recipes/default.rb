# Cookbook Name:: dbserver_mysql
# Recipe:: default
#
# Copyright 2012, RuleYourCloud
#
# All rights reserved - Do Not Redistribute
#

#suponhemos plataforma debian por defecto e actualizamos a cache do apt

#case node['platform_family']
#when "debian"
#    include_recipe "apt"
#end

## instalamos a gema de mysql para que poida 
#package 'make'
#package 'libmysqlclient-dev'

## instalamos os requisitos da gema de mysql ANTES DE QUE SE CONSTRUA A RESOURCE COLLECTION
#make = package 'make'
#make.run_action(:install)
#
#mysql_client = package "libmysqlclient-dev"
#mysql_client.run_action(:install)

#chef_gem 'mysql'


include_recipe "mysql::client"
include_recipe "mysql::ruby"



