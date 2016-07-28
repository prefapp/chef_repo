default['appserver']['nginx']['modules'] = [
    'http_ssl_module',
    'http_gzip_static_module'
]

default['appserver']['nginx']['version'] = '1.10.2'
default['appserver']['nginx']['checksum'] = '1fd35846566485e03c0e318989561c135c598323ff349c503a6c14826487a801'
# directorio de instalacion (por defecto)
default['appserver']['nginx']['install_dir'] = '/opt/nginx'

# default passenger version
default['appserver']['nginx']['passenger']['version'] = '5.0.30'
