php5_fpm_pool "www" do

	pm 				     "dynamic"
	pm_max_requests      5000
	php_ini_admin_flags	 'log_errores' => 'on'
	php_ini_admin_values 'memory_limit' => '32M'

end
