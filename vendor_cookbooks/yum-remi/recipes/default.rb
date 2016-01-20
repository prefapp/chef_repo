#
# Cookbook Name:: yum-remi
# Recipe:: default
#
# Copyright (C) 2014 Aiming Inc.
#

include_recipe "yum"

# reference from chef cookbook `yum::remi` v2.4.4
yum_repository "remi" do
  description "Les RPM de remi pour Enterprise Linux #{node['platform_version']} - $basearch"
  mirrorlist  "http://rpms.famillecollet.com/enterprise/#{node['platform_version'].to_i}/remi/mirror"
  enabled     true
  gpgcheck    true
  gpgkey      "http://rpms.famillecollet.com/RPM-GPG-KEY-remi" 

  action      :create
end
