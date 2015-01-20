default['app']['phplist']['version'] = '3.0.11'

default['app']['phplist']['default_repo_url'] = 'http://prdownloads.sourceforge.net/phplist/'

default['app']['phplist']['default_repo_type'] = 'remote_archive'

default['app']['phplist']['default_revision'] = lazy { "phplist-#{node['app']['phplist']['version']}.tgz" }

default['app']['phplist']['default_user'] = 'phplist'

default['app']['phplist']['default_group'] = 'users'

default['app']['phplist']['default_smtp_server'] = '' # localhost



