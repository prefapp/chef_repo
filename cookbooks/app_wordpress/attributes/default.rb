default['app']['wordpress']['version'] = 'latest'

default['app']['wordpress']['default_domain'] = node['fqdn']

default['app']['wordpress']['default_repo_url'] = 'https://wordpress.org/'

default['app']['wordpress']['default_repo_type'] = 'remote_archive'

default['app']['wordpress']['default_revision'] = lazy { "wordpress-#{node['app']['wordpress']['version']}.tar.gz" }

default['app']['wordpress']['default_user'] = 'wordpress'

default['app']['wordpress']['default_group'] = 'users'

default['app']['wordpress']['default_system_lang'] = 'es_ES'


