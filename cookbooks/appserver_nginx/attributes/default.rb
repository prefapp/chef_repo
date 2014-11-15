#default["appserver"]["nginx"]["version"] = "1.2.6"
#default["appserver"]["nginx"]["checksum"] = "0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388"

# default["appserver"]["nginx"]["version"] = "1.2.7"
# default["appserver"]["nginx"]["checksum"] = "2457a878943fb409ec4fcb46b43af222d06a584f93228e17a4f02b0e7bfc9de3"

#default["appserver"]["nginx"]["version"] = "1.4.1"
#default["appserver"]["nginx"]["checksum"] = "bca5d1e89751ba29406185e1736c390412603a7e6b604f5b4575281f6565d119


default["appserver"]["nginx"]["modules"] = [
    "http_ssl_module",
    "http_gzip_static_module"
]

default["appserver"]["nginx"]["version"] = "1.6.2"
default["appserver"]["nginx"]["checksum"] = "b5608c2959d3e7ad09b20fc8f9e5bd4bc87b3bc8ba5936a513c04ed8f1391a18"
# directorio de instalacion (por defecto)
default["appserver"]["nginx"]["install_dir"] = "/opt/nginx"
