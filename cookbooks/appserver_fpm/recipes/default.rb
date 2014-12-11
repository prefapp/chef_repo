#include_recipe "php-fpm::default"
#
# # creamos un pool
# php_fpm_pool "www" do
#
# 	process_manager "dynamic"
# 	max_requests 5000
# 	php_options 'php_admin_flag[log_errors]' => 'on', 'php_admin_value[memory_limit]' => '32M'
#
# end

include_recipe "php5-fpm::install"

