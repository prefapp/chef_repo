# Cookbook Name:: dbserver_mysql
# Recipe:: default
#
# Copyright 2012, RuleYourCloud
#
# All rights reserved - Do Not Redistribute
#

#suponhemos plataforma debian por defecto e actualizamos a cache do apt
include_recipe "apt"


include_recipe "mysql"
