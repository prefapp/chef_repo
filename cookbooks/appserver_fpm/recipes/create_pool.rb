php5_fpm_pool node["appserver"]["fpm"]["pools"] do
    pm                      "ondemand"
    pm_max_requests         5000
    php_ini_admin_flags     'log_errores' => 'on'
    php_ini_admin_values    'memory_limit' => '32M'

end
