#default["appserver"]["nginx"]["version"] = "1.2.6"
#default["appserver"]["nginx"]["checksum"] = "0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388"

# default["appserver"]["nginx"]["version"] = "1.2.7"
# default["appserver"]["nginx"]["checksum"] = "2457a878943fb409ec4fcb46b43af222d06a584f93228e17a4f02b0e7bfc9de3"

#default["appserver"]["nginx"]["version"] = "1.4.1"
#default["appserver"]["nginx"]["checksum"] = "bca5d1e89751ba29406185e1736c390412603a7e6b604f5b4575281f6565d119"

default["appserver"]["nginx"]["version"] = "1.4.4"
default["appserver"]["nginx"]["checksum"] = "7c989a58e5408c9593da0bebcd0e4ffc3d892d1316ba5042ddb0be5b0b4102b9"

# directorio de instalacion (por defecto)
default["appserver"]["nginx"]["install_dir"] = "/opt/nginx-#{node['appserver']['nginx']['version']}"

default["appserver"]["nginx"]["modules"] = [
    "http_ssl_module",
    "http_gzip_static_module"
]

# default["appserver"]["nginx"]["passenger"]["version"] = "3.0.19"
default["appserver"]["nginx"]["passenger"]["version"] = "4.0.29"
