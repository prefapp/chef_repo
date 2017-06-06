include_recipe "app_nodejs::default"

app = node['app']['nodejs']

#Array(node["app"]["nodejs"]["apps"]).each do |app|

	nodejs_app app['target_path'] do

    %W(
      server_alias
      target_path
      entry_point
      owner
      group
      
      repo_url
      repo_type
      revision
      purge_target_path
      repo_depth
      credential

      environment
      env_vars
      migration_command
      extra_modules
      extra_packages
      postdeploy_script
      cookbook

    ).each do |m|

      v = app[m] || node["app"]["nodejs"]["default_#{m}"]

      self.send(m,v)

    end

	end
#end
