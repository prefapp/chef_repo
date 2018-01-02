default['appserver']['nginx']['modules'] = [
    'http_ssl_module',
    'http_gzip_static_module'
]

#default['appserver']['nginx']['version'] = '1.10.2'
#default['appserver']['nginx']['checksum'] = '1045ac4987a396e2fa5d0011daf8987b612dd2f05181b67507da68cbe7d765c2'


default['appserver']['nginx']['version'] = '1.12.2'
default['appserver']['nginx']['checksum'] = '305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416'

# directorio de instalacion (por defecto)
default['appserver']['nginx']['install_dir'] = '/opt/nginx'

# default passenger version
default['appserver']['nginx']['passenger']['version'] = '5.1.12'
