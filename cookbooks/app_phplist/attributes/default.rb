default['app']['phplist']['version'] = '3.0.12'

default['app']['phplist']['domain'] = ''

default['app']['phplist']['default_repo_url'] = 'http://prdownloads.sourceforge.net/phplist/'

default['app']['phplist']['default_repo_type'] = 'remote_archive'

default['app']['phplist']['default_revision'] = lazy { "phplist-#{node['app']['phplist']['version']}.tgz" }

default['app']['phplist']['default_user'] = 'phplist'

default['app']['phplist']['default_group'] = 'users'

default['app']['phplist']['default_smtp_server'] = '' # localhost

default['app']['phplist']['default_test_mode'] = 0

default['app']['phplist']['default_bounce_address'] = nil

default['app']['phplist']['default_bounce_mailbox_host'] = 'pop3_host'

default['app']['phplist']['default_bounce_mailbox_user'] = 'username'

default['app']['phplist']['default_bounce_mailbox_password'] = 'password'

default['app']['phplist']['default_bounce_unsuscribe_threshold'] = 5

default['app']['phplist']['default_system_language'] = 'es'





