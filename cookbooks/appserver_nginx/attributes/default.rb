default['appserver']['nginx']['modules'] = [
    'http_ssl_module',
    'http_gzip_static_module'
]

#default['appserver']['nginx']['version'] = '1.10.2'
#default['appserver']['nginx']['checksum'] = '1045ac4987a396e2fa5d0011daf8987b612dd2f05181b67507da68cbe7d765c2'


default['appserver']['nginx']['version'] = '1.12.0'
default['appserver']['nginx']['checksum'] = 'b4222e26fdb620a8d3c3a3a8b955e08b713672e1bc5198d1e4f462308a795b30'

# directorio de instalacion (por defecto)
default['appserver']['nginx']['install_dir'] = '/opt/nginx'

# default passenger version
default['appserver']['nginx']['passenger']['version'] = '5.1.4'
