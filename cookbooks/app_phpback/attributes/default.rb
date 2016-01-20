default['app']['phpback']['version'] = 'v1.2.0'

default['app']['phpback']['default_domain'] = node['fqdn']

default['app']['phpback']['default_repo_url'] = 'git://github.com/ivandiazwm/phpback.git'

default['app']['phpback']['default_repo_type'] = 'git'

default['app']['phpback']['default_revision'] = lazy { node['app']['phpback']['version'] }

default['app']['phpback']['default_user'] = 'phpback'

default['app']['phpback']['default_group'] = 'phpback'

default['app']['phpback']['default_admin_user'] = 'admin'

default['app']['phpback']['default_db_type'] = 'mysql'

