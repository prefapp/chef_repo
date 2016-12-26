php_fpm_pool node["appserver"]["fpm"]["pools"] do
    process_manager         "ondemand"
    additional_config       {
      "pm_max_requests" => 5000,
      "php_admin_flag[log_errores]" => "on",
      "php_admin_value[memory_limit]" => "32M"
    }

end
