#
# Cookbook Name:: dbserver_mysql
# Recipe:: server
#
# Copyright 2012, RuleYourCloud
#
# All rights reserved - Do Not Redistribute
#

# instalamos primeiro o cliente
include_recipe "dbsystem_mysql"


include_recipe "mysql::server"
