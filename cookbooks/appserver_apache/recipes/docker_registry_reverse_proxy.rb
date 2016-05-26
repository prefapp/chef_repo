node.set["appserver"]['apache']["default_modules"] = [
  "headers",
  "authn_file",
  "authn_core",
  "authz_groupfile",
  "authz_user",
  "authz_core",
  "auth_basic",
  "access_compat",
  "log_config",
  "logio",
  "ssl",
  "proxy",
  "proxy_http",
  "unixd",
]


include_recipe "appserver_apache::default"

server_root = node["appserver"]["apache"]["conf_dir"]

template "#{server_root}/sites-available/default.conf" do
  source "docker_registry_reverse_proxy.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :server_name => "_default_",
    :redirect_http => true,
    :ssl => true,
    :server_root => server_root
  )
end

directory "#{server_root}/registry/locations" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

# creamos o vhost default e instalamos apache
apache_site "default"
