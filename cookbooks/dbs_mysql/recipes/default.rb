include_recipe "mysql::client"

# A partir da v5.0 do cookbook de mysql
# a gema ten o seu propio cookbook

#include_recipe "mysql::ruby"
include_recipe "mysql-chef_gem::default"



