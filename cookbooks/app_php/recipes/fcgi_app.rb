include_recipe "app_php::default"

php_version = node['lang']['php']['version']

if php_version =~ /^5\./
  php_version = '5'
end

Array(node["app"]["php"]["fcgi_apps"]).each do |app|

	fcgi_app app["domain"] do

    %W(
      server_alias
      target_path
      entry_point
      owner
      group
      repo_url
      repo_type
      revision
      credential
      environment
      env_vars
      static_files_path
      migration_command
      timeout
      extra_modules
      extra_packages
      postdeploy_script

      php_ini_admin_values

      purge_target_path
      repo_depth

      cookbook
      frontend_template


    ).each do |m|

      v = app[m] || node["app"]["php"]["default_#{m}"]

      self.send(m,v)

    end

    notifies   :restart, 'service[nginx]'
    #notifies   :restart, "service[php#{php_version}-fpm]"


	end
end
