default["appserver"]["nginx"]["version"] = "1.2.7"
#default["appserver"]["nginx"]["checksum"] = "0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388"
default["appserver"]["nginx"]["checksum"] = "2457a878943fb409ec4fcb46b43af222d06a584f93228e17a4f02b0e7bfc9de3"


default["appserver"]["nginx"]["modules"] = [
    "http_ssl_module",
    "http_gzip_static_module"
]

