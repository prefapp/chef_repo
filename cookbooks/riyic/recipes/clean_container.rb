if node["riyic"]["inside_container"]

  include_recipe "system_package::clean" #if node['recipes'].include?("system_package::default")

  include_recipe "lang_perl::clean_cpanm" #if node['recipes'].include?("lang_perl::default")

  #Chef::Log.fatal("RECIPES: #{node['recipes'].inspect}")

end
